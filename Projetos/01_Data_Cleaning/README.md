# Limpeza de Dados - Dataset `vendas_sujas`

##  Setup Inicial
![01 - Setup Inicial](https://raw.githubusercontent.com/gyamada22/SQL-Cleaning-Challenges/main/Projetos/01_Data_Cleaning/images/01.png)

- Configuração do ambiente no Snowflake  
- Definição de `ROLE` e `WAREHOUSE`  
- Criação de `DATABASE` e `SCHEMA`  

---

## Inserção de Dados
![Insercao de Dados](https://raw.githubusercontent.com/gyamada22/SQL-Cleaning-Challenges/main/Projetos/01_Data_Cleaning/images/Inserçao_dados.png)

- Inserção de dados brutos com inconsistências simuladas  
- Presença de duplicatas, valores nulos, formatos diferentes de datas, pesos e descontos  
- Objetivo: simular problemas reais do dataset  

---

## 01 - STA1: Remoção de Duplicadas Exatas
![STA1](https://raw.githubusercontent.com/gyamada22/SQL-Cleaning-Challenges/main/Projetos/01_Data_Cleaning/images/sta1.png)

- Utilização de `SELECT DISTINCT *`  
- Remove duplicatas perfeitas  
- Garante que registros idênticos permaneçam apenas uma vez  

---

## 02 - STA2: Padronização de Tipos
![STA2](https://raw.githubusercontent.com/gyamada22/SQL-Cleaning-Challenges/main/Projetos/01_Data_Cleaning/images/sta2.png)

- Conversão de colunas para tipos corretos (`DATE`, `NUMBER`, `DECIMAL`)  
- Padronização de formatos de datas e valores numéricos  
- Tratamento de unidades (`kg`, `g`) e símbolos (`%`)  

---

## 03 - STA3: Limpeza de Valores Negativos
![STA3](https://raw.githubusercontent.com/gyamada22/SQL-Cleaning-Challenges/main/Projetos/01_Data_Cleaning/images/sta3.png)

- Colunas numéricas com valores negativos convertidas para `NULL`  
- Garante integridade dos dados para cálculos e análises futuras  

---

## 04 - STA4: Padronização Textual
![STA4](https://raw.githubusercontent.com/gyamada22/SQL-Cleaning-Challenges/main/Projetos/01_Data_Cleaning/images/sta4.png)

- Aplicação de `TRIM` para remover espaços extras  
- Uso de `INITCAP` para capitalização correta  
- Padronização das colunas de texto (`name`, `product`, `category`, `country`)  

---

## 05 - STA5: Padronização de Valores de Referência
![STA5](https://raw.githubusercontent.com/gyamada22/SQL-Cleaning-Challenges/main/Projetos/01_Data_Cleaning/images/sta5.png)

- Ajustes finais em colunas categóricas e textuais  
- Normalização de `name` (valores nulos ou placeholders)  
- Unificação de `country` (`Br`, `Brasil` → `Brazil`)  
- Correção de `category` com grafias corretas e acentos  

---

## 06 - Hash Final
![Hash Final](https://raw.githubusercontent.com/gyamada22/SQL-Cleaning-Challenges/main/Projetos/01_Data_Cleaning/images/hashfinal.png)

- Criação de hash MD5 para cada linha (`name`, `product`, `price`, `weight`, `date`)  
- Verificação de duplicadas finais após toda a limpeza  
- Garantia de integridade e unicidade das linhas  

---

## 🔹 Resumo de Técnicas de Limpeza Utilizadas

Estas são as principais técnicas aplicadas neste projeto, que podem ser reutilizadas em outras limpezas de dados:

---

## 09 - README do Projeto
![README](https://raw.githubusercontent.com/gyamada22/SQL-Cleaning-Challenges/main/Projetos/01_Data_Cleaning/images/readme.md)

- Documento explicativo das etapas de limpeza  
- Referência para replicação do processo ou análises futuras  
- Registro das decisões e transformações aplicadas ao dataset  
