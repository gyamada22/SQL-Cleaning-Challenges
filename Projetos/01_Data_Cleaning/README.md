# Limpeza de Dados - Dataset 01

---

## 🔹 Padrão de Limpeza de Dados Utilizado

Antes de qualquer etapa prática de limpeza, adoto o seguinte padrão, que serve como guia para manter consistência, rastreabilidade e qualidade dos dados:

### 1. Entendimento da Base
- Checar tipos de colunas e colunas nulas ou inúteis para o BI final  
- Fazer estatísticas rápidas (`MIN/MAX/MÉDIA`) para entender distribuição de colunas numéricas  
- Contar valores distintos (`DISTINCT COUNT`) das colunas não numéricas  
- Documentar observações para guiar etapas posteriores  

### 2. Remoção Inicial de Duplicatas
- Remover registros **totalmente idênticos** em todas as colunas  
- Reduz o volume de dados e otimiza o processamento das etapas seguintes  

### 3. Padronização de Colunas
- Corrigir tipos de dados (ex.: `STRING` → `INT/DECIMAL/DATE`)  
- Renomear colunas para `snake_case` ou nomes padronizados  
- Remover espaços e caracteres especiais indesejados (initcap + trim)
- Padronizar valores nulos (`'', None, NULL, N/A`)  
- Padronizar datas para um único formato  

### 4. Tratamento de Valores Nulos
- Avaliar quantidade de nulos por coluna  
- Decidir se será preenchido com `NULL`, média, moda ou outro valor adequado  
- Depende do impacto na análise ou BI final  

### 5. Remoção Secundária de Duplicatas
- Após padronização de valores e colunas, remover duplicatas que estavam "disfarçadas"  

### 6. Normalização de Dados
- Tornar os dados **comparáveis e modeláveis** para BI ou análise  
- Ex.: converter gramas → quilogramas, porcentagens → decimal, padronizar casas decimais  

### 7. Conferência Final
- Uso de **hash de linha** para validar duplicatas finais e garantir integridade do dataset  
- Permite confirmar que cada registro é único mesmo após todas as padronizações  

---

## 🔹 Resumo de Técnicas de Limpeza Utilizadas

Estas são as principais técnicas aplicadas neste projeto, que podem ser reutilizadas em outras limpezas de dados:

### 1. Padronização de valores nulos
  - Transformar valores inconsistentes ou placeholders em `NULL`:
```sql  
CASE 
    WHEN coluna IN ('', 'None', 'null', 'NULL', 'N/A') THEN NULL 
    ELSE coluna 
END AS coluna
```

### 2. Padronização de texto
  - Remover espaços extras e capitalizar corretamente:
```sql 
INITCAP(TRIM(coluna)) AS coluna
```

### 3. Remoção de duplicadas
  - Remover linhas completamente iguais:
```sql 
SELECT DISTINCT * FROM tabela
```

### 4. Conversão de tipos
  - Converter colunas para tipos adequados:
```sql 
TRY_TO_NUMBER(coluna) AS coluna_int
TRY_TO_DECIMAL(coluna) AS coluna_decimal
TRY_TO_DATE(coluna) AS coluna_date
```

### 5. Tratamento de datas inconsistentes
  - Padronizar diferentes formatos de datas para um único padrão:
```sql 
TRY_TO_DATE(REPLACE(REPLACE(order_date, '/', '-'), '.','-')) AS date
```



---

##  Setup Inicial - Snowflake
![Snowflake Screen](https://raw.githubusercontent.com/gyamada22/SQL-Cleaning-Challenges/main/Projetos/01_Data_Cleaning/images/screen_snowflake.png)

- Configuração do ambiente no Snowflake  
- Definição de `ROLE` e `WAREHOUSE`  
- Criação de `DATABASE` e `SCHEMA`  

---

## Inserção de Dados
```sql 
INSERT INTO treino_limpeza.raw.vendas_sujas VALUES
('011',' Lucas Pereira ','TV','Eletronicos','2025-01-11','Brazil','1','2500','5%','12kg'),
('011',' Lucas Pereira ','TV','Eletronicos','2025-01-11','Brazil','1','2500','5%','12kg'), 

('012','None','Geladeira','Eletrodomésticos','11/01/2025','BR','1','3500.90','0.1','60 KG'),
('013',NULL,'Fogão','eletrodomesticos','2025/01/12','Brasil','2','1800,00','10%','45kg'),

('014','  ','Liquidificador','Cozinha','2025.01.12','brasil','1','250','NULL','2kg'),
('015','Mariana','Liquidificador','cozinha','12-01-2025','Brazil ','1','250','null','2000g'),

('016','Paulo','Notebook','Eletrônicos','invalid','BRASIL','1','4000','','2 KG'),
('017','paulo','Notebook','Eletronicos','2025-01-13','BR','1','4.000','0%','2000 g'),

('018','Ana','Cadeira','Moveis','2025-13-01','Brazil','1','800','5%','15kg'),
('019','Ana','Cadeira','Móveis','2025-01-14','Brazil','1','800','5%','15000g'),

('020','Rafael','Mesa','Moveis','2025-01-14','Brasil','-2','600','10%','20kg'),

('021','Bruna','Mouse','Perifericos','2025-01-15','BR','2','80','0','100g'),
('022','Bruna ','Mouse','Periféricos','15/01/2025','Brazil','2','80.00','0%','0.1kg'),

('023','João','Teclado','Perifericos','2025-01-16','brazil','1','200','5%','0,5kg'),
('024','João','Teclado','Periféricos','2025-01-16','BR','1','200','0.05','500g'),

('025','Carlos','Monitor','Eletrônicos','2025-01-17','Brazil','1','1200',' ','3kg'),
('026','Carlos','Monitor','Eletrônicos','17/01/2025','Brasil','1','1200','None','3000 g'),

('027','NULL','Impressora','Escritório','2025-01-18','BR','1','900','5%','8kg'),
('028','Renata','Impressora','Escritorio','18-01-2025','Brazil','1','900','0.05','8000g'),

('029','Renata','Impressora','Escritório','2025-01-18','BR','1','900','5%','8 KG'), 

('030','Felipe','Câmera','Eletronicos','2025/01/19','br','1','2300,50','10%','1kg'),
('031','Felipe','Câmera','Eletrônicos','2025-01-19','BR','1','2300.50','0.1','1000 g'),

('032','Amanda','Tripé','Acessorios','2025-01-20','Brazil','3','150','5%','500g'),
('033','Amanda','Tripé','Acessórios','20/01/2025','Brasil','3','150','0.05','0.5kg'),

('034','Tiago','Fone','Acessorios','2025-01-21','BRASIL','2','200','NULL','200g'),
('035','Tiago','Fone','Acessórios','2025-01-21','BR','2','200','','0.2kg'),

('036','Sandra','Notebook','Eletrônicos','2025-01-22','Brazil','1','NULL','10%','2kg'),
('037','Sandra','Notebook','Eletrônicos','2025-01-22','Brazil','1','','0.1','2000g'),

('038','Victor','Celular','Eletronicos','2025-01-23','BR','1','2500','-5%','0.2kg'),
('039','Victor','Celular','Eletrônicos','23/01/2025','Brasil','1','2500','-0.05','200g'),

('040',' ','Mousepad','Perifericos','2025-01-24','Brazil','1','50','5%','50g'),
('041',NULL,'Mousepad','Periféricos','24/01/2025','BR','1','50','0.05','0.05kg');
```
- Inserção de dados brutos com inconsistências simuladas  
- Presença de duplicatas, valores nulos, formatos diferentes de datas, pesos e descontos  
- Objetivo: simular problemas reais do dataset  

---

## 01 - STA1: Remoção de Duplicadas Exatas
```sql 
CREATE OR REPLACE TABLE sta1 AS (
    SELECT DISTINCT * 
    FROM treino_limpeza.raw.vendas_sujas
);
```
- Utilização de `SELECT DISTINCT *`  
- Remove duplicatas perfeitas  
- Garante que registros idênticos permaneçam apenas uma vez  

---

## 02 - STA2: Padronização de Tipos
```sql 
CREATE OR REPLACE TABLE sta2 AS (
    SELECT  
        order_id AS id,
        customer_name AS name,
        product,
        category,
        try_to_date(replace(replace(order_date, '/', '-'), '.','-')) AS date,
        country,
        try_to_number(quantity) AS quantity,
        try_to_decimal(price) AS price,
        CAST(
            try_to_decimal(replace(discount,'%',''),10,2) / 
            CASE WHEN discount LIKE '%\%%' THEN 100 ELSE 1 END
            AS decimal(10,2)
        ) AS discount,
        try_to_decimal(replace(replace(lower(weight),'kg',''),'g','')) * 
        CASE WHEN lower(weight) LIKE '%kg' THEN 1000 ELSE 1 END AS weight
    FROM sta1
);
```
- Conversão de colunas para tipos corretos (`DATE`, `NUMBER`, `DECIMAL`)  
- Padronização de formatos de datas e valores numéricos  
- Tratamento de unidades (`kg`, `g`) e símbolos (`%`)  

---

## 03 - STA3: Limpeza de Valores Negativos
```sql
CREATE OR REPLACE TABLE sta3 AS (
    SELECT  
        id, name, product, category, date, country,
        CASE WHEN quantity < 0 THEN NULL ELSE quantity END AS quantity,
        CASE WHEN price < 0 THEN NULL ELSE price END AS price,
        CASE WHEN discount < 0 THEN NULL ELSE discount END AS discount,
        CASE WHEN weight < 0 THEN NULL ELSE weight END AS weight
    FROM sta2
);
```
- Colunas numéricas com valores negativos convertidas para `NULL`  
- Garante integridade dos dados para cálculos e análises futuras  

---

## 04 - STA4: Padronização Textual
```sql 
CREATE OR REPLACE TABLE sta4 AS (
    SELECT  
        id, date, quantity, price, discount, weight,
        initcap(trim(name)) AS name,
        initcap(trim(product)) AS product,
        initcap(trim(category)) AS category,
        initcap(trim(country)) AS country
    FROM sta3
);
```
- Aplicação de `TRIM` para remover espaços extras  
- Uso de `INITCAP` para capitalização correta  
- Padronização das colunas de texto (`name`, `product`, `category`, `country`)  

---

## 05 - STA5: Padronização de Valores de Referência
```sql
CREATE OR REPLACE TABLE sta5 AS (
    SELECT  
        id, date, quantity, price, discount, weight, product,
        CASE WHEN name IN ('', 'None', 'null', 'NULL','N/A') THEN NULL ELSE name END AS name,
        CASE 
            WHEN country = 'Br' THEN 'Brazil'
            WHEN country = 'Brasil' THEN 'Brazil'
            ELSE country
        END AS country,
        CASE 
            WHEN category = 'Acessorios' THEN 'Acessórios'
            WHEN category = 'Eletrodomesticos' THEN 'Eletrodomésticos'
            WHEN category = 'Eletronicos' THEN 'Eletrônicos'
            WHEN category = 'Escritorio' THEN 'Escritório'
            WHEN category = 'Moveis' THEN 'Móveis'
            WHEN category = 'Perifericos' THEN 'Periféricos'
            ELSE category
        END AS category
    FROM sta4
);
```
- Ajustes finais em colunas categóricas e textuais  
- Normalização de `name` (valores nulos ou placeholders)  
- Unificação de `country` (`Br`, `Brasil` → `Brazil`)  
- Correção de `category` com grafias corretas e acentos  

---

## 06 - Hash Final
```sql
WITH hashes AS (
    SELECT *,
        MD5(CONCAT_WS('/', name, product, price, weight, date)) AS row_hash
    FROM sta5
)
SELECT row_hash, COUNT(*) AS cnt
FROM hashes
GROUP BY row_hash
HAVING cnt > 1
ORDER BY cnt DESC;
```
- Criação de hash MD5 para cada linha (`name`, `product`, `price`, `weight`, `date`)  
- Verificação de duplicadas finais após toda a limpeza  
- Garantia de integridade e unicidade das linhas  

---
