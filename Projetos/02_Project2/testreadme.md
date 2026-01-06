# 🏦 Projeto End-to-End: Engenharia e Analytics de Churn Bancário

Este repositório contém uma solução completa de dados, desde a ingestão bruta até à visualização estratégica, focada na retenção de clientes bancários. O projeto utiliza uma arquitetura moderna de dados (Modern Data Stack) para transformar dados operacionais em inteligência de negócio.

---

## 🏗️ Arquitetura Técnica

O pipeline foi desenhado seguindo os princípios de **DataOps**, utilizando contentores para isolamento e ferramentas de transformação baseadas em SQL.



### 1. Orquestração e Infraestrutura (Apache Airflow & Docker)
* **Controlo de Fluxo:** Utilização do **Apache Airflow** para gerir o ciclo de vida dos dados, garantindo que a transformação só ocorre após o sucesso da ingestão.
* **Isolamento:** Todo o ambiente (Airflow, Postgres, dbt) corre em **Docker**, eliminando o problema de "funciona na minha máquina".
* **Monitorização:** Acompanhamento de performance via **Gantt Charts** e **Grid Views** para identificar gargalos (Ingestão atual: ~4s).

### 2. Ingestão de Dados (Camada Bronze - Raw)
* **Fonte:** Dataset de churn bancário (Kaggle).
* **Processo:** Script Python robusto que utiliza `SQLAlchemy` para carregar dados brutos no **Snowflake**.
* **Carga:** Automática, via DAG, garantindo que o Data Warehouse está sempre sincronizado.

### 3. Transformação e Modelagem (Camada Silver - Staging)
* **Ferramenta:** **dbt (data build tool)**.
* **Lógica de Negócio:** - Padronização de nomes de colunas (CamelCase para Snake_Case/Uppercase).
    - Tipagem estrita: Conversão de campos categóricos e numéricos para análise.
    - Persistência: Dados transformados no schema `SILVER` para garantir integridade.
* **Qualidade:** Validação física dos dados no Snowflake via role `ACCOUNTADMIN`.

### 4. Visualização e Suporte Estratégico (Power BI - Em Andamento)
* **Conectividade:** Ligação direta ao Snowflake via modo **Importar** para alta performance.
* **Foco Estratégico:** - **KPIs de Retenção:** Taxa de Churn (%) Geral.
    - **Segmentação Geográfica:** Análise por país (França, Alemanha, Espanha) para suporte operacional.
    - **Insights de Comportamento:** Relação entre o uso de produtos (`HasCrCard`, `IsActiveMember`) e a saída do cliente.

---

## 🛠️ Skills Aplicadas (ID 328)

| Skill | Categoria | Tipo |
| :--- | :--- | :--- |
| **Apache Airflow** | Orquestração | **Obrigatório** |
| **dbt (data build tool)** | Transformação | **Obrigatório** |
| **SQL (Snowflake)** | Data Warehouse | **Obrigatório** |
| **Power BI** | Visualização | **Obrigatório** |
| **Bibliotecas Python** | Análise e ETL | **Obrigatório** |

---

## 🚀 Como Executar
1. `docker-compose up` para iniciar o Airflow.
2. Ativar a DAG `pipeline_churn_bancario_end_to_end`.
3. Consultar os dados transformados no Snowflake.
4. Abrir o ficheiro `.pbix` para visualizar os insights.
