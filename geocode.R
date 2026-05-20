# ===================================================================
# FASE 2: GEOCODIFICAÇÃO OFICIAL COM GEOCODEBR (IPEA)
# ===================================================================

rm(list = ls()); gc()

# Instalação automática de pacotes com tratamento de permissão de Administrador
pacotes <- c("DBI", "RSQLite", "geocodebr", "dplyr", "stringr")
faltando <- pacotes[!(pacotes %in% installed.packages()[,"Package"])]

if (length(faltando) > 0) {
  cat("Instalando pacotes faltantes:", paste(faltando, collapse = ", "), "\n")
  
  # Cria uma biblioteca pessoal na pasta de usuário para evitar bloqueio do Windows
  user_lib <- Sys.getenv("R_LIBS_USER")
  if (!dir.exists(user_lib)) {
    dir.create(user_lib, recursive = TRUE, showWarnings = FALSE)
  }
  
  # Adiciona a pasta pessoal aos caminhos do R e força a instalação nela
  .libPaths(c(user_lib, .libPaths()))
  install.packages(faltando, lib = user_lib, repos = "https://cloud.r-project.org/")
}

suppressPackageStartupMessages({
  library(DBI)
  library(RSQLite)
  library(geocodebr)
  library(dplyr)
  library(stringr)
})

# Caminho absoluto do banco (Atualizado com seu usuário)
CAMINHO_DB <- "C:/Users/Mateus Joter/Desktop/CNPJ/dados_receita.db"

cat("==================================================\n")
cat(" INICIANDO FASE 2: GEOCODIFICAÇÃO (R)\n")
cat("==================================================\n")

# Tenta estabelecer a conexão com proteção contra erros
con <- tryCatch({
  dbConnect(RSQLite::SQLite(), dbname = CAMINHO_DB)
}, error = function(e) {
  stop("ERRO CRÍTICO: Não foi possível conectar ao banco SQLite. Verifique o caminho.\nDetalhe: ", e$message)
})

# Criação da tabela final que armazenará as latitudes e longitudes
tryCatch({
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS enderecos_geocodificados_final (
      cnpj_completo TEXT PRIMARY KEY,
      rua_buscada TEXT,
      numero TEXT,
      bairro TEXT,
      municipio TEXT,
      uf TEXT,
      cep TEXT,
      latitude REAL,
      longitude REAL,
      precisao_geocodebr TEXT,
      view_origem TEXT
    )
  ")
}, error = function(e) {
  dbDisconnect(con)
  stop("Erro ao criar a tabela final: ", e$message)
})

cat("Lendo dados preparados pela IA (Python)...\n")

# Query incremental: lê apenas o que foi preparado mas ainda não geocodificado
query <- "
  SELECT * FROM enderecos_preparados
  WHERE cnpj_completo NOT IN (SELECT cnpj_completo FROM enderecos_geocodificados_final)
"

df_preparado <- tryCatch({
  dbGetQuery(con, query)
}, error = function(e) {
  dbDisconnect(con)
  stop("Erro ao ler tabela 'enderecos_preparados'. O script Python foi executado com sucesso?\nDetalhe: ", e$message)
})

if (nrow(df_preparado) > 0) {
  cat("Iniciando geocodificação de", nrow(df_preparado), "registros...\n")

  # 1. Preparação interna de colunas para o geocodebr
  df_preparado$id_interno <- seq_len(nrow(df_preparado))

  # Concatena tipo de logradouro e nome do logradouro garantindo que não fiquem 'NAs'
  df_preparado$rua_completa <- trimws(paste(
    ifelse(is.na(df_preparado$tipo_logradouro), "", df_preparado$tipo_logradouro),
    ifelse(is.na(df_preparado$logradouro), "", df_preparado$logradouro)
  ))

  # Garante que o CEP contenha apenas números (remove hífens ou pontos)
  df_preparado$cep_limpo <- str_remove_all(df_preparado$cep, "[^0-9]")

  # Trata números nulos ou sem número (S/N)
  df_preparado$numero_limpo <- ifelse(df_preparado$numero %in% c("S/N", "SN", "S/Nº", ""), NA, df_preparado$numero)

  # 2. Definição do mapeamento de campos exigido pelo geocodebr
  campos <- definir_campos(
    logradouro = "rua_completa",
    numero     = "numero_limpo",
    localidade = "bairro",      # O argumento correto no pacote é 'localidade'
    municipio  = "municipio",
    estado     = "uf",
    cep        = "cep_limpo"
  )

  # 3. Execução do motor de busca
  cat("  Acessando bases oficiais de endereçamento (aguarde)...\n")
  resultado_geo <- tryCatch({
    geocode(
      enderecos          = df_preparado,
      campos_endereco    = campos,
      resultado_completo = TRUE,
      resolver_empates   = TRUE,
      verboso            = FALSE
    )
  }, error = function(e) {
    dbDisconnect(con)
    stop("Ocorreu um erro interno no motor do geocodebr: ", e$message)
  })

  # 4. Unificação dos resultados com o dataframe original
  geo_df <- as.data.frame(resultado_geo)
  df_final <- merge(
    x = df_preparado,
    y = geo_df[, c("id_interno", "lat", "lon", "tipo_resultado")],
    by = "id_interno",
    all.x = TRUE
  )

  # 5. Traduz a precisão (códigos CNEFE do geocodebr) e organiza as colunas para o BD
  df_salvar <- df_final %>%
    mutate(
      precisao_traduzida = case_when(
        str_starts(as.character(tipo_resultado), "pn|dn") ~ "Endereço Exato (Porta/Número)",
        str_starts(as.character(tipo_resultado), "pa|da") ~ "Número Aproximado na Rua",
        str_starts(as.character(tipo_resultado), "pl|dl") ~ "Logradouro (Apenas a Rua)",
        str_starts(as.character(tipo_resultado), "dc")    ~ "Centroide do CEP",
        str_starts(as.character(tipo_resultado), "db")    ~ "Centroide do Bairro",
        str_starts(as.character(tipo_resultado), "dm")    ~ "Centroide do Município",
        is.na(tipo_resultado) ~ NA_character_,
        TRUE ~ as.character(tipo_resultado) # Fallback: mantém original se for algo novo
      )
    ) %>%
    select(
      cnpj_completo,
      rua_buscada = rua_completa,
      numero, bairro, municipio, uf, cep,
      latitude = lat,
      longitude = lon,
      precisao_geocodebr = precisao_traduzida,
      view_origem
    )

  cat("Salvando", nrow(df_salvar), "registros com coordenadas no banco de dados...\n")

  # 6. Salva na tabela final
  tryCatch({
    dbAppendTable(con, "enderecos_geocodificados_final", df_salvar)
    
    n_sucesso <- sum(!is.na(df_salvar$latitude))
    n_total <- nrow(df_salvar)
    taxa <- round((n_sucesso / n_total) * 100, 1)

    cat(sprintf("\n[✔] Processo concluído com sucesso!\n"))
    cat(sprintf("    Coordenadas encontradas: %d de %d (Taxa de sucesso: %s%%)\n", n_sucesso, n_total, taxa))

  }, error = function(e) {
    cat("[ERRO] Falha ao salvar os resultados no banco: ", e$message, "\n")
  })

} else {
  cat("\n[i] Não há novos registros na tabela intermediária para serem geocodificados no momento.\n")
}

# Encerramento seguro da conexão
dbDisconnect(con)
cat("\n==================================================\n")
cat(" PIPELINE FINALIZADO.\n")
cat("==================================================\n")