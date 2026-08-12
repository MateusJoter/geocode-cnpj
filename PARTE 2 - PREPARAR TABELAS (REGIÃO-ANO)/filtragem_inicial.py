import sqlite3
import os

# ==============================================================================
# CONFIGURAÇÕES E PARÂMETROS
# ==============================================================================

REGIOES = ["DF", "RMF", "RMG", "RMSP", "RMRJ"]
ANOS = [1990, 2000, 2010, 2025]

# Lista de CNAEs Principais de interesse
CNAES_PRINCIPAIS = [
    '4531701','4531702','4541201','4541202','4621400','4622200','4623101','4623106',
    '4623109','4631100','4632001','4632003','4633801','4634601','4634602','4634603',
    '4635401','4635402','4635499','4636201','4637101','4637199','4639701','4639702',
    '4641901','4642701','4643501','4644301','4645101','4646001','4647801','4649401',
    '4649402','4649408','4649499','4651601','4652400','4661300','4662100','4663000',
    '4664800','4665600','4669901','4669999','4671100','4672900','4673700','4674500',
    '4679601','4679699','4681801','4682600','4683400','4684299','4685100','4686901',
    '4687701','4687702','4689301','4689399','4691500','4692300','4693100','5211701',
    '5211799','5212500','5229099','5250803','5250804','5250805'
]

# Prefixos e códigos para filtro em CNAE Secundário
CNAES_SECUNDARIOS_LIKE = [
    '%4531701%', '%4531702%', '%462%', '%463%', '%464%', '%465%', 
    '%466%', '%467%', '%468%', '%469%', '%52117%', '%52125%', '%52508%'
]

# Palavras-chave na Razão Social para o fallback do CNAE 8888888
TERMOS_RAZAO_SOCIAL = [
    'ALIMENT', 'BEBIDA', 'DISTRIB', 'ATACAD', 'LATICIN', 'FRIGORIF', 
    'FABRICA', 'INDUSTRIA', 'TRANSPORTE', 'LOGISTICA', 'AUTO PECAS', 
    'COMERCIO', 'MERCADO', 'ARMAZEM'
]

# Naturezas Jurídicas válidas
NATUREZAS_JURIDICAS = [
    'Empresa Pública', 'Sociedade de Economia Mista', 'Sociedade Anônima Aberta', 
    'Sociedade Anônima Fechada', 'Sociedade Empresária Limitada', 'Sociedade Empresária em Nome Coletivo', 
    'Sociedade Empresária em Comandita Simples', 'Sociedade Empresária em Comandita por Ações', 
    'Sociedade Mercantil de Capital e Indústria', 'Sociedade em Conta de Participação', 
    'Empresário (Individual)', 'Cooperativa', 'Consórcio de Sociedades', 'Grupo de Sociedades', 
    'Estabelecimento, no Brasil, de Sociedade Estrangeira', 
    'Estabelecimento, no Brasil, de Empresa Binacional Argentino-Brasileira', 
    'Empresa Domiciliada no Exterior', 'Clube/Fundo de Investimento', 'Sociedade Simples Pura', 
    'Sociedade Simples Limitada', 'Sociedade Simples em Nome Coletivo', 
    'Sociedade Simples em Comandita Simples', 'Empresa Binacional', 'Consórcio de Empregadores', 
    'Consórcio Simples', 'Empresa Individual de Responsabilidade Limitada (de Natureza Empresária)', 
    'Empresa Individual de Responsabilidade Limitada (de Natureza Simples)', 
    'Sociedade Unipessoal de Advocacia', 'Cooperativas de Consumo', 'Empresa Simples de Inovação'
]

# ==============================================================================
# FUNÇÃO GERADORA DE SQL
# ==============================================================================

def gerar_sql_view(regiao: str, ano: int) -> str:
    """
    Gera a instrução SQL DDL para criação de uma View regional/histórica.
    """
    nome_view = f"{regiao}_{ano}"
    data_limite_str = f"{ano}1231"
    
    # Formatação das cláusulas IN e LIKE
    cnaes_principal_sql = ",\n            ".join([f"'{c}'" for c in CNAES_PRINCIPAIS])
    cnaes_secundario_sql = "\n            OR ".join([f"cnae_fiscal_secundaria LIKE '{s}'" for s in CNAES_SECUNDARIOS_LIKE])
    termos_razao_sql = "\n                OR ".join([f"UPPER(razao_social) LIKE '%{t}%'" for t in TERMOS_RAZAO_SOCIAL])
    naturezas_sql = ",\n            ".join([f"'{n}'" for n in NATUREZAS_JURIDICAS])
    
    sql = f"""-- --- View para Região {regiao} - Ano {ano} ---
DROP VIEW IF EXISTS {nome_view};
CREATE VIEW {nome_view} AS
SELECT * FROM {regiao}
WHERE (
    -- 1. Regra de CNAE Principal, Secundário ou Fallback (8888888)
    (
        cnae_fiscal_principal IN (
            {cnaes_principal_sql}
        )
        OR (
            {cnaes_secundario_sql}
        )
        OR (
            (cnae_fiscal_principal = '8888888' OR cnae_fiscal_principal IS NULL OR cnae_fiscal_principal = '')
            AND (
                {termos_razao_sql}
            )
        )
    )

    -- 2. Regra de Porte e Natureza Jurídica
    AND (porte_empresa IN ('EMPRESA DE PEQUENO PORTE', 'DEMAIS') OR porte_empresa IS NULL)
    AND (
        natureza_juridica IN (
            {naturezas_sql}
        )
        OR natureza_juridica IS NULL
    )

    -- 3. Regra Temporal (Formato DD/MM/YYYY convertido para YYYYMMDD)
    AND (
        (
            SUBSTR(data_inicio_atividade, 7, 4) || 
            SUBSTR(data_inicio_atividade, 4, 2) || 
            SUBSTR(data_inicio_atividade, 1, 2)
        ) <= '{data_limite_str}'

        AND (
            situacao_cadastral IN (2, '2')
            OR (
                SUBSTR(data_situacao_cadastral, 7, 4) || 
                SUBSTR(data_situacao_cadastral, 4, 2) || 
                SUBSTR(data_situacao_cadastral, 1, 2)
            ) > '{data_limite_str}'
        )
    )
);
"""
    return sql

# ==============================================================================
# PIPELINE DE EXECUÇÃO
# ==============================================================================

def compilar_script_unificado(arquivo_saida="script_views_completo.sql"):
    """
    Gera um arquivo .sql unificado com todas as views de todas as regiões e anos.
    """
    print(f"Gerando script unificado em '{arquivo_saida}'...")
    
    with open(arquivo_saida, "w", encoding="utf-8") as f:
        f.write("-- ==========================================================================================\n")
        f.write("-- SCRIPT AUTOMÁTICO: CRIAÇÃO DE VIEWS HISTÓRICAS REGIONAIS\n")
        f.write(f"-- Regiões: {', '.join(REGIOES)}\n")
        f.write(f"-- Anos: {', '.join(map(str, ANOS))}\n")
        f.write("-- ==========================================================================================\n\n")
        
        total_views = 0
        for regiao in REGIOES:
            f.write(f"-- {'='*88}\n")
            f.write(f"-- REGIÃO: {regiao}\n")
            f.write(f"-- {'='*88}\n\n")
            
            for ano in ANOS:
                sql_view = gerar_sql_view(regiao, ano)
                f.write(sql_view + "\n")
                total_views += 1
                
    print(f"Sucesso! {total_views} Views geradas com sucesso no arquivo SQL.\n")


def aplicar_views_no_banco(caminho_db_sqlite: str):
    """
    Opcional: Conecta em um banco SQLite existente e aplica todas as Views geradas.
    """
    if not os.path.exists(caminho_db_sqlite):
        print(f"Aviso: Banco de dados '{caminho_db_sqlite}' não encontrado.")
        return
    
    print(f"Conectando ao banco de dados '{caminho_db_sqlite}' para aplicar as Views...")
    conn = sqlite3.connect(caminho_db_sqlite)
    cursor = conn.cursor()
    
    for regiao in REGIOES:
        for ano in ANOS:
            sql = gerar_sql_view(regiao, ano)
            # Executa os comandos (DROP VIEW e CREATE VIEW)
            cursor.executescript(sql)
            print(f" -> View {regiao}_{ano} criada/atualizada.")
            
    conn.commit()
    conn.close()
    print("Todas as views foram aplicadas no banco de dados com sucesso!")

# ==============================================================================
# EXECUÇÃO PRINCIPAL
# ==============================================================================

if __name__ == "__main__":
    # 1. Gera o arquivo .sql completo com todas as views combinadas
    compilar_script_unificado("script_views_completo.sql")
    
    # 2. Se desejar rodar diretamente no banco SQLite, descomente a linha abaixo:
    aplicar_views_no_banco(r"C:\Users\Mateus Joter\Desktop\CNPJ\dados_receita.db")