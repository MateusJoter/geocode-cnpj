# 📍 Geocode CNPJ: Pipeline Híbrido de Geocodificação (Python + R)

Este repositório contém um pipeline automatizado de ponta a ponta para **limpeza, padronização e geocodificação** de dados de empresas oriundos da base de CNPJs da Receita Federal do Brasil.

A arquitetura foi desenhada de forma híbrida para extrair o melhor de duas ferramentas: a inteligência analítica do **Python** com modelos generativos da Google (Gemini) e o poder estatístico/espacial do **R** com o pacote oficial `geocodebr` (IPEA).

---

## 🏗️ Arquitetura do Pipeline

O processo é incremental, transacional via SQLite e dividido em duas fases críticas:

```
[ Banco SQLite ] 
       │
       ▼
 ┌───────────┐      ┌──────────────┐
 │  FASE 1   │ ───> │ API Gemini   │ (Isola registros únicos e remove complementos
 │ (Python)  │ <─── │ 3.1 Flash    │  que atrapalham a busca espacial)
 └───────────┘      └──────────────┘
       │
       ▼ (Salva na tabela: enderecos_preparados)
 ┌───────────┐      ┌──────────────┐
 │  FASE 2   │ ───> │  geocodebr   │ (Consulta bases oficiais do IBGE, CNEFE
 │    (R)    │ <─── │   (CNEFE)    │  e Correios de forma offline/local)
 └───────────┘      └──────────────┘
       │
       ▼
[ Tabela Final: enderecos_geocodificados_final ]
```

### 🐍 Fase 1: Limpeza e Padronização Inteligente (Python)

* **Estratégia de Custo/Eficiência:** O script lê as views brutas de CNPJ do banco SQLite, filtra apenas registros não processados e isola apenas os **endereços únicos** para evitar chamadas duplicadas e desperdício de tokens na API.
* **Engenharia de Prompt:** O modelo `gemini-3.1-flash-lite-preview` atua como um especialista em endereçamento brasileiro para remover ruídos textuais (ex: *Loja X, Bloco Y, Fundos, Sala 12*) mantendo a estrutura essencial de rodovias e cidades planejadas.
* **Resiliência:** Possui tratamento de erros com *Exponential Backoff* e um *fallback* inteligente que preserva o dado original caso o lote falhe, garantindo que o pipeline não pare em bases massivas.

### 📊 Fase 2: Geocodificação Oficial de Alta Precisão (R)

* **Motor Espacial:** Consome os endereços limpos pelo Python através do pacote `geocodebr` (desenvolvido pelo IPEA), que realiza o cruzamento de dados com bases locais oficiais do Brasil (CNEFE/IBGE e Correios).
* **Classificação de Precisão:** Traduz nativamente as respostas do algoritmo em categorias de acurácia legíveis no banco de dados, mapeando desde "Endereço Exato (Porta/Número)" até "Centroide do CEP".

---

## 📂 Estrutura de Arquivos

* **`preparar_enderecos.py`**: Script em Python responsável pela conexão com o SQLite, particionamento de lotes (`tqdm`) e tratamento via API Google GenAI.
* **`geocode.R`**: Script em R responsável pela ingestão dos dados preparados, limpeza de strings de CEP/Número e execução do motor de geocodificação.
* **`executar_pipeline.bat`**: Arquivo de lote (Batch Windows) que orquestra a execução sequencial de ambas as linguagens com verificação rigorosa de erros (`ERRORLEVEL`).

---

## 🛠️ Pré-requisitos e Dependências

### No Ambiente Python

Instale os pacotes necessários via terminal:

```bash
pip install pandas google-genai tqdm
```

> 🔑 **Configuração da API:** Crie um arquivo texto chamado `gemini_apikey.txt` na raiz do projeto e cole a sua chave de API do Gemini nele (em texto puro).

### No Ambiente R

O script possui rotina de **autoinstalação segura**. Caso os pacotes abaixo não existam na máquina, ele criará automaticamente uma biblioteca de usuário local (`R_LIBS_USER`) contornando problemas de privilégios de Administrador no Windows.

* `DBI` / `RSQLite`
* `geocodebr` (IPEA)
* `dplyr` / `stringr`

---

## 🚀 Como Executar

Certifique-se de configurar o caminho do seu banco de dados SQLite (`dados_receita.db`) nos arquivos `preparar_enderecos.py` e `geocode.R`.

Para rodar todo o fluxo de forma sequencial e automatizada no Windows, basta dar dois cliques no arquivo orquestrador:

```bash
executar_pipeline.bat
```

O utilitário imprimirá os logs em tempo real no terminal informando a quantidade de novos registros processados, falhas e a **Taxa de Sucesso (%)** final de coordenadas encontradas.
