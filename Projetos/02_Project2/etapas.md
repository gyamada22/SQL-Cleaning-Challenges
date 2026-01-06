# 📅 Linha do Tempo: Projeto ID 233 (Setor Financeiro)

## 🏗️ Fase 1: Fundação e Infraestrutura
* **Docker** | *Diferencial*
    * Configuração do arquivo `docker-compose.yaml` para subir o **Apache Airflow** e as dependências de ambiente.
* **Snowflake** | *Diferencial*
    * Criação da estrutura de bancos de dados e schemas (`BRONZE`, `SILVER`, `GOLD`) via SQL para recepção dos dados.

## 📥 Fase 2: Ingestão e Orquestração
* **Python (Bibliotecas Python: Pandas)** | *Diferencial*
    * Desenvolvimento do script de "Ingestão Leve": leitura do CSV original, padronização técnica de colunas e carga na camada `BRONZE`.
* **Apache Airflow** | **Obrigatório**
    * Criação da primeira DAG para automatizar e agendar a execução do script de ingestão Python.

## 🧠 Fase 3: Analytics Engineering
* **dbt (SQL)** | *Diferencial*
    * **Limpeza (Silver):** Modelagem SQL para tratamento de valores nulos, duplicatas e conformidade.
    * **Negócio (Gold):** Construção de tabelas agregadas com métricas financeiras (ex: Score de Crédito).
    * **Testes:** Implementação de testes automatizados de qualidade de dados via dbt.
* **Apache Airflow** | **Obrigatório**
    * Configuração da orquestração final: disparar o comando `dbt run` automaticamente após o sucesso da ingestão.

## 📊 Fase 4: Entrega de Valor (Insights)
* **Power BI** | **Obrigatório**
    * Conexão com a camada `GOLD` do Snowflake para visualização dos dados tratados.
* **Análise Estratégica** | **Obrigatório**
    * Criação de visuais para analisar dados e gerar insights para suportar decisões estratégicas e operacionais (ex: análise de limite de crédito).
