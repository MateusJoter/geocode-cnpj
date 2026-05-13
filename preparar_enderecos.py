import sqlite3
import pandas as pd
import io
import os
import time
from google import genai
from tqdm import tqdm

# =============================================================================
# CONFIGURAÇÕES GERAIS E BANCO DE DADOS
# =============================================================================
# Caminho do banco SQLite (ajuste conforme o seu ambiente local)
DB_PATH = r"C:\Users\SeuUsuario\Desktop\CNPJ\dados_receita.db"

# Lista de views/tabelas que contém os dados brutos a serem limpos
VIEWS_PARA_PROCESSAR = ["view_cidade_A", "view_brasilia", "view_cidade_C"]

def inicializar_gemini():
    """Inicializa o cliente da API do Gemini lendo a chave de um arquivo."""
    try:
        if not os.path.exists("gemini_apikey.txt"):
            raise FileNotFoundError("Arquivo 'gemini_apikey.txt' não encontrado.")
            
        with open("gemini_apikey.txt", "r", encoding="utf-8") as f:
            gemini_apikey = f.read().strip()
            
        if not gemini_apikey:
            raise ValueError("A chave de API no arquivo está vazia.")
            
        return genai.Client(api_key=gemini_apikey)
    except Exception as e:
        print(f"[ERRO] Falha ao inicializar o Gemini: {e}")
        return None

def limpar_com_gemini(client, df_unicos):
    """
    Recebe um DataFrame com endereços únicos, envia para o Gemini limpar 
    sujeiras como 'SALA', 'LOTE', 'GALPAO' e retorna os dados tratados.
    """
    print(f"  Enviando {len(df_unicos)} endereços únicos para o Gemini...")
    
    # Monta a string CSV para enviar no prompt
    csv_in = "tipo_logradouro;logradouro\n" + "\n".join(
        df_unicos['tipo_logradouro'].fillna('').astype(str) + ";" + 
        df_unicos['logradouro'].fillna('').astype(str)
    )

    prompt = f"""
    Atue como um especialista em geolocalização brasileira. 
    Trate os logradouros abaixo para otimizar buscas no pacote R 'geocodebr' / IBGE.
    
    REGRAS CRÍTICAS:
    1. Remova informações de complemento que confundem o mapa (ex: "LOTE X", "SALA Y", "PARTE B", "GALPAO", "CONJUNTO", "BLOCO", "LOJA").
    2. Mantenha siglas de Brasília intactas (ex: "SHCS CR 516", "SAAN QUADRA 2", "BR 020 KM 2").
    3. Devolva APENAS os dados tratados no formato CSV separados por ';', com cabeçalho 'tipo_logradouro_tratado;logradouro_tratado'.
    4. Mantenha EXATAMENTE a mesma quantidade de linhas e a ordem original.
    5. Não inclua formatação markdown na resposta, apenas texto puro.
    
    Dados:
    {csv_in}
    """

    max_tentativas = 4
    espera_base = 5  # Segundos. O tempo dobrará a cada falha (5s, 10s, 20s).

    for tentativa in range(1, max_tentativas + 1):
        try:
            # Chamada ao modelo Flash Lite (rápido e econômico para processamento em lote)
            response = client.models.generate_content(
                model='gemini-3.1-flash-lite-preview',
                contents=prompt
            )
            
            texto_resposta = response.text.strip()
            
            # Limpeza de markdown caso a IA inclua acidentalmente
            if texto_resposta.startswith("```"):
                linhas = texto_resposta.split("\n")
                if len(linhas) > 2:
                    texto_resposta = "\n".join(linhas[1:-1])

            # Converte a resposta CSV de volta para DataFrame
            df_tratado = pd.read_csv(io.StringIO(texto_resposta), sep=";")
            
            # Validação de segurança para garantir integridade do merge
            if len(df_tratado) != len(df_unicos):
                print(f"  [AVISO] Gemini retornou {len(df_tratado)} linhas. Esperado: {len(df_unicos)}. Usando dados originais.")
                # Se o erro for de formato da resposta e não de conexão, encerramos a tentativa
                return None

            # Adiciona colunas tratadas ao DataFrame de únicos
            df_unicos = df_unicos.reset_index(drop=True)
            df_unicos['tipo_log_limpo'] = df_tratado.iloc[:, 0]
            df_unicos['log_limpo'] = df_tratado.iloc[:, 1]
            
            return df_unicos
            
        except Exception as e:
            print(f"  [AVISO] Tentativa {tentativa}/{max_tentativas} falhou: {e}")
            if tentativa < max_tentativas:
                tempo_espera = espera_base * (2 ** (tentativa - 1)) # Backoff exponencial
                print(f"  [i] Congestionamento detectado. Aguardando {tempo_espera}s para tentar de novo...")
                time.sleep(tempo_espera)
            else:
                print(f"  [ERRO CRÍTICO] Falha definitiva com o Gemini após {max_tentativas} tentativas.")
                return None

def processar_pipeline():
    """
    Acessa o SQLite, lê as views, faz o cruzamento com o Gemini 
    e salva os resultados na tabela intermediária.
    """
    client = inicializar_gemini()
    if not client:
        print("Pipeline abortado devido a erro de API.")
        return

    try:
        conn = sqlite3.connect(DB_PATH)
        
        # Cria a tabela intermediária que servirá de ponte para o motor em R
        conn.execute("""
            CREATE TABLE IF NOT EXISTS enderecos_preparados (
                cnpj_completo TEXT PRIMARY KEY,
                tipo_logradouro TEXT,
                logradouro TEXT,
                numero TEXT,
                bairro TEXT,
                municipio TEXT,
                uf TEXT,
                cep TEXT,
                view_origem TEXT
            )
        """)
        
        for view in VIEWS_PARA_PROCESSAR:
            print(f"\n--- Processando View: {view} ---")
            
            try:
                # Query inteligente: busca apenas CNPJs que ainda não foram preparados (Anti-Duplicação)
                query = f"""
                    SELECT * FROM {view} 
                    WHERE cnpj_completo NOT IN (SELECT cnpj_completo FROM enderecos_preparados)
                """
                df = pd.read_sql(query, conn)
                
                if df.empty:
                    print("  Todos os registros desta view já foram preparados.")
                    continue
                    
                print(f"  Encontrados {len(df)} novos registros.")
                
                # Isola endereços únicos para economizar requisições à IA
                df_unicos = df[['tipo_logradouro', 'logradouro']].drop_duplicates()
                df_unicos_tratados = limpar_com_gemini(client, df_unicos)
                
                if df_unicos_tratados is not None:
                    # Merge dos dados limpos de volta para o DataFrame completo
                    df = df.merge(df_unicos_tratados, on=['tipo_logradouro', 'logradouro'], how='left')
                    
                    # Estrutura a tabela final para inserção no banco
                    df_final = pd.DataFrame({
                        'cnpj_completo': df['cnpj_completo'],
                        'tipo_logradouro': df['tipo_log_limpo'], # Dado limpo
                        'logradouro': df['log_limpo'],           # Dado limpo
                        'numero': df['numero'],
                        'bairro': df['bairro'],
                        'municipio': df['municipio'],
                        'uf': df['uf'],
                        'cep': df['cep'],
                        'view_origem': view
                    })
                    
                    # Salva no banco (Append)
                    df_final.to_sql('enderecos_preparados', conn, if_exists='append', index=False)
                    print(f"  Salvos {len(df_final)} registros limpos na tabela intermediária.")
                else:
                    print("  Pulando salvamento devido a erro no tratamento.")
                    
            except pd.errors.DatabaseError as e:
                print(f"  [ERRO] Falha ao ler ou escrever a view '{view}': {e}")
                
    except sqlite3.Error as db_err:
        print(f"[ERRO CRÍTICO] Problema na conexão com o banco de dados: {db_err}")
    finally:
        if 'conn' in locals():
            conn.close()
            print("Conexão com o banco encerrada.")

if __name__ == '__main__':
    print("==================================================")
    print(" INICIANDO FASE 1: LIMPEZA E PADRONIZAÇÃO (PYTHON)")
    print("==================================================")
    processar_pipeline()
    print("\n[✔] Fase 1 concluída! Os dados estão prontos para o motor em R.")