Fase,Etapa,Ferramenta,O que deve ser feito?,Classificação
1. Infra,Configuração de Ambiente,Docker,Criar o arquivo docker-compose.yaml para subir o Airflow e as dependências locais.,Diferencial
1. Infra,Data Warehouse,Snowflake,"Criar as bases de dados e os schemas (BRONZE, SILVER, GOLD) via SQL.",Diferencial
2. Ingestão,Extração e Load (EL),Python (Pandas),"Script para ler o CSV (Kaggle), renomear colunas e carregar na BRONZE.",Bibliotecas Python
2. Ingestão,Orquestração Inicial,Apache Airflow,Criar a DAG que agenda e executa o script Python automaticamente.,Obrigatório
3. Transform,Limpeza e Qualidade,dbt (SQL),"Criar modelos SQL para limpar nulos, duplicatas e padronizar o dado na SILVER.",Diferencial
3. Transform,Regra de Negócio,dbt (SQL),Criar tabelas GOLD com métricas financeiras (ex: Cálculo de Risco de Crédito).,Diferencial
4. Entrega,Insights Estratégicos,Power BI,Conectar na GOLD e criar visuais para suporte à decisão (ex: Aumento de limite).,Obrigatório
4. Entrega,Documentação,dbt docs,Gerar o portal de linhagem de dados para mostrar como o dado fluiu.,Diferencial
