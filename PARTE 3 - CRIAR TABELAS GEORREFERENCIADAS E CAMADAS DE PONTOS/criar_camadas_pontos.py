import os
import sqlite3
import pandas as pd
import geopandas as gpd
from shapely.geometry import Point
from sqlalchemy import create_engine

# ==============================================================================
# CONFIGURAÇÕES E PARÂMETROS
# ==============================================================================

# Definição das Regiões e Anos conforme as views/tabelas históricas
REGIOES = ["DF", "RMF", "RMG", "RMSP", "RMRJ"]
ANOS = [1990, 2000, 2010, 2025]

# Diretorio onde os arquivos .gpkg serão salvos
PASTA_SAIDA_GPKG = "camadas_gpkg"

# Configuração da Conexão com o Banco de Dados
# Para SQLite, informe o caminho do arquivo .db
CAMINHO_BANCO_SQLITE = r"C:\Users\Mateus Joter\Desktop\CNPJ\dados_receita.db"

# Caso utilize outro SGBD (PostgreSQL / DuckDB), utilize a String de conexão SQLAlchemy:
# URI_BANCO = "postgresql://usuario:senha@localhost:5432/nome_banco"
URI_BANCO = f"sqlite:///{CAMINHO_BANCO_SQLITE}"


# ==============================================================================
# 1. FUNÇÃO PARA CRIAR TABELAS GEORREFERENCIADAS NO BANCO
# ==============================================================================

def executar_script_sql_criacao_tabelas(engine, arquivo_sql="criar_tabelas_coordenadas.sql"):
    """
    Executa a criação das tabelas georreferenciadas executando o script SQL.
    """
    if os.path.exists(arquivo_sql):
        print(f"Executando script SQL de junção: '{arquivo_sql}'...")
        with open(arquivo_sql, "r", encoding="utf-8") as f:
            script_sql = f.read()
        
        with engine.begin() as conexao:
            # Divide o script em comandos por ponto e vírgula
            comandos = [cmd.strip() for cmd in script_sql.split(";") if cmd.strip()]
            for cmd in comandos:
                conexao.exec_driver_sql(cmd)
        print("Tabelas georreferenciadas criadas/atualizadas com sucesso no banco de dados!")
    else:
        print(f"Aviso: O arquivo SQL '{arquivo_sql}' não foi encontrado. Prosseguindo com a exportação...")


# ==============================================================================
# 2. FUNÇÃO PARA EXPORTAR TABELA PARA GEOPACKAGE (.GPKG)
# ==============================================================================

def exportar_tabela_para_gpkg(nome_tabela: str, engine, pasta_destino: str):
    """
    Lê a tabela georreferenciada do banco, constrói a geometria de pontos
    e salva em formato GeoPackage (.gpkg).
    """
    print(f"\n[+] Processando tabela: {nome_tabela}...")
    
    # Consulta a tabela do banco
    query = f"SELECT * FROM {nome_tabela}"
    try:
        df = pd.read_sql_query(query, engine)
    except Exception as e:
        print(f"    [!] Erro ao ler tabela '{nome_tabela}': {e}")
        return

    if df.empty:
        print(f"    [i] Tabela '{nome_tabela}' está vazia. Pulando exportação.")
        return

    # Garante que latitude e longitude sejam numéricas
    df['latitude'] = pd.to_numeric(df['latitude'], errors='coerce')
    df['longitude'] = pd.to_numeric(df['longitude'], errors='coerce')

    # Remove registros sem coordenadas válidas
    df_valido = df.dropna(subset=['latitude', 'longitude']).copy()
    num_removidos = len(df) - len(df_valido)
    if num_removidos > 0:
        print(f"    [i] Descartados {num_removidos} registros com coordenadas nulas/inválidas.")

    if df_valido.empty:
        print(f"    [!] Nenhum ponto válido encontrado em '{nome_tabela}'.")
        return

    # Cria a coluna de geometria Point (Longitude, Latitude)
    geometria = [Point(xy) for xy in zip(df_valido['longitude'], df_valido['latitude'])]
    
    # Converte o DataFrame para GeoDataFrame com Sistema de Referência de Coordenadas WGS84 (EPSG:4326)
    gdf = gpd.GeoDataFrame(df_valido, geometry=geometria, crs="EPSG:4326")

    # Define o caminho do arquivo GPKG de saída
    caminho_gpkg = os.path.join(pasta_destino, f"{nome_tabela}.gpkg")
    
    # Salva no formato GeoPackage (camada nomeada com o próprio nome da tabela)
    gdf.to_file(caminho_gpkg, driver="GPKG", layer=nome_tabela)
    print(f"    [✓] GeoPackage gerado: {caminho_gpkg} ({len(gdf)} feições)")


# ==============================================================================
# PIPELINE PRINCIPAL DE EXECUÇÃO
# ==============================================================================

def main():
    # Cria a pasta de destino dos arquivos GeoPackage se não existir
    os.makedirs(PASTA_SAIDA_GPKG, exist_ok=True)
    
    # Conecta ao Banco de Dados
    engine = create_engine(URI_BANCO)

    # Passo 1: Executa o script SQL para criar as tabelas no BD
    executar_script_sql_criacao_tabelas(engine, "criar_tabelas_coordenadas.sql")

    # Passo 2: Iteração sobre as regiões e anos para gerar os arquivos GPKG
    print("\n" + "="*80)
    print("INICIANDO CONVERSÃO DAS TABELAS PARA ARQUIVOS GEOPACKAGE (.GPKG)")
    print("="*80)

    total_exportados = 0
    for regiao in REGIOES:
        for ano in ANOS:
            nome_tabela = f"{regiao}_{ano}_georreferenciado"
            exportar_tabela_para_gpkg(nome_tabela, engine, PASTA_SAIDA_GPKG)
            total_exportados += 1

    print("\n" + "="*80)
    print(f"PROCESSAMENTO CONCLUÍDO! Total de {total_exportados} camadas GPKG geradas em '{PASTA_SAIDA_GPKG}/'.")
    print("="*80)

if __name__ == "__main__":
    main()