# Tech Layoffs — End-to-End Data Cleaning & ETL Pipeline (Snowflake)

- Este projeto demonstra a construção de um pipeline completo de **Data Cleaning e ETL** utilizando **Snowflake** e a **Medallion Architecture (Bronze, Silver e Gold)**.  
- O objetivo é transformar dados brutos e inconsistentes sobre layoffs em um dataset **confiável, padronizado e pronto para análises analíticas e BI**.

## Objetivo do Projeto
- Limpar e padronizar dados reais com múltiplas inconsistências.
- Garantir **qualidade, integridade e consistência** antes do consumo analítico.
- Construir um pipeline **reprodutível, idempotente e auditável**.
- Simular um cenário próximo ao ambiente produtivo de dados.

## Stack Tecnológica
- **Plataforma:** Snowflake (Cloud Data Warehouse)
- **Linguagem:** SQL (CTEs, Window Functions, Defensive SQL)
- **Arquitetura:** Medallion Architecture (Bronze / Silver / Gold)

> A escolha do Snowflake se deu pela possibilidade de executar todo o pipeline sem billing ativo. A mesma estrutura funcionaria da mesma forma em BigQuery ou Redshift com pequenas adaptações.
---

## 🔄 Arquitetura do Pipeline

### 🟤 Camada Bronze — Raw

Armazena os dados em seu estado original (`STG_LAYOFFS_RAW`), sem qualquer transformação.

**Principais problemas identificados:**
- Datas armazenadas como strings.
- Colunas numéricas com valores inválidos.
- Strings como `'null'`, `'NULL'` e espaços vazios representando valores nulos.
- Inconsistências de capitalização, digitação e categorização.
- Registros duplicados.

### ⚪ Camada Silver — Conformed

Camada responsável pela **limpeza, padronização e aplicação de regras de negócio**.  
As transformações foram implementadas utilizando **CTEs encadeadas**, garantindo **legibilidade, modularidade e facilidade de auditoria**.

#### Principais Transformações

- **Padronização de Nulos**  
  Conversão de strings inválidas (`'null'`, `'NULL'`, espaços em branco) em `NULL` real utilizando `TRIM()`.

- **Tipagem Defensiva de Dados**  
  Uso de `TRY_CAST` e `TRY_TO_DATE` para evitar falhas no pipeline causadas por dados inesperados.

- **Normalização de Texto**  
  - `INITCAP()` para Company, Location, Industry e Country.  
  - `UPPER()` para Stage, garantindo consistência visual.

- **Imputação e Regras de Negócio**  
  Preenchimento manual de indústrias ausentes para empresas específicas:
  - Airbnb → Travel  
  - Carvana → Transportation  
  - Juul → Consumer  

- **Correção de Inconsistências de Domínio**  
  - Unificação de categorias (`Cryptocurrency`, `Crypto Currency` → `Crypto`).  
  - Correção de nomes de países (`United States.` → `United States`).

- **Deduplicação**  
  Remoção de registros duplicados utilizando `ROW_NUMBER()` com `PARTITION BY` em todas as colunas relevantes, garantindo um resultado determinístico.

### 🟡 Camada Gold — Analytics

Camada final otimizada para consumo analítico.

- **Filtro de Relevância**  
  Remoção de registros sem métricas essenciais (`Total_Laid_Off` e `Percentage_Laid_Off`).

- **Organização Temporal**  
  Dados organizados cronologicamente, facilitando análises históricas, dashboards e relatórios executivos.

> A camada Gold está pronta para integração com ferramentas de BI como Power BI ou Tableau.

---
## Estrutura do Script SQL

O pipeline da camada Silver foi organizado em CTEs, cada uma com uma responsabilidade clara:

1.  `cte1_standarize1`: Limpeza técnica e tipagem defensiva.
2.  `cte2_standarize2`: Padronização estética e capitalização.
3.  `cte3_imputation`: Regras de negócio e imputações manuais.
4.  `cte4_deduplicate`: Remoção de duplicatas.

---

## Lições Aprendidas

- Dados devem ser limpos **antes** da deduplicação para garantir resultados corretos.
- `TRY_CAST` é essencial para pipelines robustos em ambientes com dados reais.
- Separar limpeza técnica de regras de negócio melhora a clareza e escalabilidade do código.
- A Medallion Architecture facilita auditoria, versionamento e crescimento do projeto.

