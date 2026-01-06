# Relatório de Status: Projeto End-to-End de Churn Bancário

## 🚀 Visão Geral
O projeto consiste num pipeline de dados automatizado para analisar a rotatividade (churn) de clientes bancários, integrando ferramentas modernas de engenharia e análise de dados.

---

## 🏗️ Arquitetura e Engenharia (Concluído)

1. **Orquestração e Contentorização:**
   - O ambiente foi isolado utilizando **Docker** para garantir a reprodutibilidade.
   - O **Apache Airflow** atua como o orquestrador central, gerindo as dependências entre as tarefas.
   - A DAG `pipeline_churn_bancario_end_to_end` está operacional e estável.

2. **Ingestão de Dados (Camada Bronze):**
   - Script Python automatizado que extrai dados do Kaggle e os carrega diretamente para o **Snowflake**.
   - Performance validada: a carga total de dados ocorre em aproximadamente 4 segundos.

3. **Transformação de Dados (Camada Silver):**
   - Utilização do **dbt (data build tool)** para transformar dados brutos em tabelas limpas e tipadas.
   - Os modelos SQL (`stg_churn`) garantem que os dados no esquema `SILVER` estão prontos para análise.
   - Validação física realizada no Snowflake através da role `ACCOUNTADMIN`.

---

## 📊 Integração e Visualização (Em Curso)

1. **Conectividade:**
   - O **Power BI Desktop** já foi configurado para se conectar ao data warehouse Snowflake.
   - Foi utilizado o modo **Importar** para garantir a melhor performance nas análises.
   - Servidor configurado: `kdbkqea-gk51114.snowflakecomputing.com`.

2. **Próximos Passos (Dashboards):**
   - **Objetivo:** Analisar dados e gerar insights para suportar decisões estratégicas e operacionais.
   - **Prioridade 1:** Criar visual de **Churn por Geografia** para identificar regiões críticas.
   - **Prioridade 2:** Desenvolver medidas DAX para KPI de Taxa de Churn (%) e análise por perfil de cliente (Idade e Saldo).

---

## 🛠️ Stack Tecnológica & Skills (ID 326)
| Skill | Categoria | Classificação |
| :--- | :--- | :--- |
| **Apache Airflow** | Orquestração | **Obrigatório** |
| **dbt (data build tool)** | Transformação | **Obrigatório** |
| **SQL (Snowflake)** | Data Warehouse | **Obrigatório** |
| **Power BI** | Visualização | **Obrigatório** |
| **Bibliotecas Python** | Pandas, SQLAlchemy | **Obrigatório** |
