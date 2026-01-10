-- STA1 = remover linhas duplicadas exatas
CREATE OR REPLACE TABLE sta1 AS (
    SELECT DISTINCT * 
    FROM treino_limpeza.raw.vendas_sujas
);


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
