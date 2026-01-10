# Limpeza de Dados - Dataset `vendas_sujas`

## Setup inicial

USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE DATABASE treino_limpeza;
CREATE OR REPLACE SCHEMA treino_limpeza.raw;

CREATE OR REPLACE TABLE treino_limpeza.raw.vendas_sujas (
    order_id STRING,
    customer_name STRING,
    product STRING,
    category STRING,
    order_date STRING,
    country STRING,
    quantity STRING,
    price STRING,
    discount STRING,
    weight STRING
);

## Inserção de dados com erros simulados

INSERT INTO treino_limpeza.raw.vendas_sujas VALUES
('011',' Lucas Pereira ','TV','Eletronicos','2025-01-11','Brazil','1','2500','5%','12kg'),
('011',' Lucas Pereira ','TV','Eletronicos','2025-01-11','Brazil','1','2500','5%','12kg'), -- duplicado perfeito
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
('029','Renata','Impressora','Escritório','2025-01-18','BR','1','900','5%','8 KG'), -- duplicata disfarçada
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

SELECT * FROM treino_limpeza.raw.vendas_sujas;
SELECT TOP 100 * FROM treino_limpeza.raw.vendas_sujas;

WITH qwe AS (
    SELECT COUNT(*) cnt, order_id
    FROM treino_limpeza.raw.vendas_sujas
    GROUP BY order_id
    HAVING COUNT(*) > 1
)
SELECT cnt FROM qwe WHERE cnt > 1;

-- STA1 = remover linhas duplicadas exatas
CREATE OR REPLACE TABLE sta1 AS (
    SELECT DISTINCT * 
    FROM treino_limpeza.raw.vendas_sujas
);
SELECT * FROM sta1 ORDER BY order_id;

-- STA2 = arrumar type das colunas
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
SELECT * FROM sta2 ORDER BY id;

-- STA3 padronizar colunas numéricas de negativo para NULL
CREATE OR REPLACE TABLE sta3 AS (
    SELECT  
        id, name, product, category, date, country,
        CASE WHEN quantity < 0 THEN NULL ELSE quantity END AS quantity,
        CASE WHEN price < 0 THEN NULL ELSE price END AS price,
        CASE WHEN discount < 0 THEN NULL ELSE discount END AS discount,
        CASE WHEN weight < 0 THEN NULL ELSE weight END AS weight
    FROM sta2
);
SELECT * FROM sta3 ORDER BY id;

-- STA4 = initcap + trim
CREATE OR REPLACE TABLE sta4 AS (
    SELECT  
        id, date, quantity, price, discount, weight,
        initcap(trim(name)) AS name,
        initcap(trim(product)) AS product,
        initcap(trim(category)) AS category,
        initcap(trim(country)) AS country
    FROM sta3
);
SELECT * FROM sta4 ORDER BY id;
SELECT DISTINCT category FROM sta4 ORDER BY category;

-- STA5 padronizar coluna category, country e name
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
SELECT * FROM sta5 ORDER BY id;
SELECT DISTINCT product FROM sta5 ORDER BY product;

-- Verificação de duplicadas pós padronização
WITH qwe AS (
    SELECT name, product, price, weight, COUNT(id) AS cnt
    FROM sta5
    GROUP BY name, product, price, weight
)
SELECT cnt, name, product, price, weight
FROM qwe
WHERE cnt > 1
ORDER BY name, product, price, weight;

SELECT * FROM sta5 WHERE name = 'Sandra' ORDER BY id;

-- Hash de linha para conferência final
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

-- Tabela final pronta
SELECT * FROM sta5 ORDER BY id;
