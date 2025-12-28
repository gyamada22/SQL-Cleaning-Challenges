# Tech Layoffs: Data Cleaning & ETL Pipeline (Snowflake)

Este projeto demonstra a implementação de um pipeline de dados completo utilizando a **Arquitetura Medalhão** (Bronze, Silver e Gold) dentro do Snowflake. O foco principal foi a transformação de dados brutos de demissões (layoffs) em um dataset limpo, consistente e pronto para análise.



## Objetivo do Projeto
Limpar e padronizar um dataset com diversas inconsistências (valores nulos em formato de string, erros de digitação, duplicidade e falta de tipagem) para garantir a integridade dos dados antes de qualquer análise de negócio.

## Stack Tecnológica
* **Plataforma:** Snowflake (Cloud Data Warehouse)
* **Linguagem:** SQL (Common Table Expressions - CTEs)
* **Estrutura:** Arquitetura Medalhão

---

## O Pipeline de Dados

### 1. Camada Bronze (Raw)
Representa os dados em seu estado original, carregados a partir do arquivo `STG_LAYOFFS_RAW`.
* **Problemas Identificados:** Datas como strings, colunas numéricas com formato incorreto, presença de textos como `'null'` ou espaços vazios onde deveriam ser valores nulos reais.

### 2. Camada Silver (Conformed)
Nesta etapa, apliquei as principais transformações de engenharia de dados através de CTEs encadeadas:

* **Padronização de Nulos:** Conversão de strings `'null'`, `'NULL'` e espaços em branco em `NULL` real através da função `TRIM`.
* **Tipagem de Dados:** Conversão segura de tipos de dados usando `TRY_CAST` (para inteiros e floats) e `TRY_TO_DATE` para garantir que datas no formato `MM/DD/YYYY` fossem processadas corretamente.
* **Normalização de Texto:** * Uso de `INITCAP()` para nomes de empresas, localizações e indústrias.
    * Uso de `UPPER()` para a coluna de estágio (`Stage`), garantindo consistência visual.
* **Imputação de Dados:** Preenchimento manual de setores ausentes para empresas específicas como Airbnb (Travel), Carvana (Transportation) e Juul (Consumer).
* **Correção de Erros de Digitação:** Unificação de categorias de indústria (ex: transformar `Cryptocurrency` e `Crypto Currency` em apenas `Crypto`) e correção de nomes de países (ex: `United States.` para `United States`).
* **Deduplicação:** Utilização da Window Function `ROW_NUMBER()` com `PARTITION BY` em todas as colunas para identificar e remover registros idênticos, mantendo apenas a entrada mais relevante.



### 3. Camada Gold (Analytics/Fact)
A camada final de entrega onde os dados estão prontos para o consumo:
* **Filtro de Relevância:** Remoção de registros que não possuíam as métricas principais (`Total_Laid_Off` e `Percentage_Laid_Off`).
* **Ordenação:** Dados organizados cronologicamente para facilitar análises históricas.

---

## Estrutura do Script SQL

O script foi desenvolvido utilizando **CTEs (Common Table Expressions)** para garantir que o código seja modular e fácil de ler:

1.  `cte1_standarize1`: Limpeza técnica e conversão de tipos.
2.  `cte2_standarize2`: Padronização estética e capitalização.
3.  `cte3_imputation`: Aplicação de regras de negócio e correções manuais.
4.  `cte4_deduplicate`: Limpeza de duplicatas.

---

## Lições Aprendidas
* A importância de limpar os dados **antes** de tentar remover duplicatas (dados sujos impedem que o SQL identifique linhas iguais).
* O uso de `TRY_CAST` como uma prática de defesa para evitar que o pipeline quebre com valores inesperados.
* A organização em camadas (Bronze/Silver/Gold) facilita a manutenção e a auditoria dos dados.

---
