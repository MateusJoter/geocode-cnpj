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
DB_PATH = r"C:\Users\Mateus Joter\Desktop\CNPJ\dados_receita.db"

# Lista de views/tabelas que contém os dados brutos a serem limpos
VIEWS_PARA_PROCESSAR = [
    # Distrito Federal
    "DF_1990", "DF_2000", "DF_2010", 
    
    # Região Metropolitana de Fortaleza
    "RMF_1990", "RMF_2000", "RMF_2010", 
    
    # Região Metropolitana de Goiânia
    "RMG_1990", "RMG_2000", "RMG_2010", 
    
    # Região Metropolitana de São Paulo
    "RMSP_1990", "RMSP_2000", "RMSP_2010", 
    
    # Região Metropolitana do Rio de Janeiro
    "RMRJ_1990", "RMRJ_2000", "RMRJ_2010"
]

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

def limpar_com_gemini(client, df_unicos, tamanho_lote=300):
    """
    Recebe um DataFrame com endereços únicos, divide em lotes para evitar 
    limite de tokens de saída da IA, envia para o Gemini limpar e 
    usa o TQDM para exibir uma barra de progresso animada.
    """
    print(f"  Preparando {len(df_unicos)} endereços únicos. Processando em lotes de {tamanho_lote}...")
    
    df_resultados = []
    
    # Implementação do TQDM: barra de progresso visual iterando sobre os lotes
    for i in tqdm(range(0, len(df_unicos), tamanho_lote), desc="Limpando com IA", unit="lote", colour="green"):
        lote = df_unicos.iloc[i:i+tamanho_lote].copy()
        
        # Monta a string CSV apenas para o lote atual
        csv_in = "tipo_logradouro;logradouro\n" + "\n".join(
            lote['tipo_logradouro'].fillna('').astype(str) + ";" + 
            lote['logradouro'].fillna('').astype(str)
        )

        prompt = f"""
        Atue como um especialista em geolocalização e endereçamento brasileiro.
        Trate e padronize os logradouros abaixo para otimizar o índice de acerto de coordenadas no pacote R 'geocodebr' (bases do IBGE e Correios).
        
        REGRAS CRÍTICAS:
        1. REMOVA complementos que atrapalham buscas espaciais (ex: "SALA X", "LOJA Y", "LOTE Z", "BLOCO", "APTO", "ANDAR", "GALPAO", "CONJUNTO", "PARTE B", "FUNDOS", "AO LADO DE").
        2. PRESERVE formatações essenciais como rodovias (ex: "BR 116 KM 12", "CE 040") e sistemas de cidades planejadas ou zonas rurais (ex: "QUADRA 8", "SHCS CR 516", "Q 104 SUL", "GLEBA 2", "CHACARA 5").
        3. PADRONIZE a grafia dos tipos de logradouro caso estejam abreviados de forma confusa.
        4. Devolva APENAS os dados tratados no formato CSV separados por ';', com cabeçalho 'tipo_logradouro_tratado;logradouro_tratado'.
        5. Mantenha EXATAMENTE a mesma quantidade de linhas e a ordem original dos dados.
        6. Não inclua formatação markdown na resposta (como ```csv), apenas texto puro.
        
        Dados:
        {csv_in}
        """

        max_tentativas = 4
        espera_base = 5

        for tentativa in range(1, max_tentativas + 1):
            try:
                response = client.models.generate_content(
                    model='gemini-3.1-flash-lite',
                    contents=prompt
                )
                
                texto_resposta = response.text.strip()
                
                # Limpeza de markdown
                if texto_resposta.startswith("```"):
                    linhas = texto_resposta.split("\n")
                    if len(linhas) > 2:
                        texto_resposta = "\n".join(linhas[1:-1])

                df_tratado = pd.read_csv(io.StringIO(texto_resposta), sep=";")
                
                # Validação crítica para garantir a integridade do lote
                if len(df_tratado) != len(lote):
                    raise ValueError(f"Divergência de linhas: esperado {len(lote)}, recebido {len(df_tratado)}")

                # Sucesso: adiciona aos resultados e sai do loop de tentativas
                df_resultados.append(df_tratado)
                break 
                
            except Exception as e:
                if tentativa < max_tentativas:
                    tempo_espera = espera_base * (2 ** (tentativa - 1))
                    # Congelamento silencioso (sleep) para não quebrar o layout visual da barra do tqdm
                    time.sleep(tempo_espera)
                else:
                    # Fallback Inteligente: Se a IA travar nesse lote específico, 
                    # devolvemos o dado original sujo apenas para esse lote, para salvar o resto do progresso!
                    df_fallback = pd.DataFrame({
                        'c1': lote['tipo_logradouro'],
                        'c2': lote['logradouro']
                    })
                    df_resultados.append(df_fallback)

    # Consolida todos os lotes finalizados
    df_final_tratado = pd.concat(df_resultados, ignore_index=True)
    
    # Adiciona as colunas limpas de volta ao DataFrame de únicos original
    df_unicos = df_unicos.reset_index(drop=True)
    df_unicos['tipo_log_limpo'] = df_final_tratado.iloc[:, 0]
    df_unicos['log_limpo'] = df_final_tratado.iloc[:, 1]
    
    return df_unicos

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