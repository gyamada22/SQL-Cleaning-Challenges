USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE treino_limpeza;
USE SCHEMA raw;

CREATE OR REPLACE TABLE treino_limpeza.raw.vendas_sujas2 (
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

INSERT INTO treino_limpeza.raw.vendas_sujas2 VALUES
('1001',' João Silva ','Notebook','Eletronicos','2025-02-01','BR','1','4500','10%','2kg'),
('1001',' João Silva ','Notebook','Eletronicos','2025-02-01','BR','1','4500','10%','2kg'), -- duplicata exata

('1002','Maria','Notebook','Eletrônicos','01/02/2025','Brasil','2','4.500,00','0.1','2000 g'),
('1003','None','Celular','Eletronicos','2025/02/02','BRASIL','1','2500','5%','180g'),
('1004','   ','Celular','Eletronicos','2025.02.02','br','1','2.500','0.05','0.18kg'),

('1005','Carlos','Monitor','Moveis','invalid','Brazil','1','1200','NULL','3kg'),
('1006','Carlos','Monitor','Móveis','2025-02-03','BR','1','1.200,00','','3000g'),

('1007','Ana','Teclado','Perifericos','2025-02-04','Brazil','-1','200','5%','500g'),
('1008','Ana','Teclado','Periféricos','04-02-2025','BR','1','200','0.05','0.5kg'),

('1009','Pedro','Mouse','Perifericos','2025-02-05','Brasil','2','80','0','100 g'),
('1010','Pedro ','Mouse','Periféricos','05/02/2025','BR','2','80.00','0%','0.1kg'),

('1011','Julia','Cadeira','Moveis','2025-02-06','Brazil ','1','800','5%','15kg'),
('1012','Julia','Cadeira','Móveis','06/02/2025','BR','1','800','0.05','15000g'),

('1013','Rafael','Mesa','Moveis','2025-02-07','BR','-2','600','10%','20kg'),
('1014','Rafael','Mesa','Móveis','07/02/2025','Brasil','2','600','0.1','20000 g'),

('1015','NULL','Impressora','Escritorio','2025-02-08','BR','1','900','5%','8kg'),
('1016','Renata','Impressora','Escritório','08/02/2025','Brazil','1','900','0.05','8000g'),

('1017','Felipe','Camera','Eletronicos','2025/02/09','brasil','1','2300,50','10%','1kg'),
('1018','Felipe','Câmera','Eletrônicos','2025-02-09','BR','1','2300.50','0.1','1000 g'),

('1019','Amanda','Tripé','Acessorios','2025-02-10','Brazil','3','150','5%','500g'),
('1020','Amanda','Tripe','Acessórios','10/02/2025','Brasil','3','150','0.05','0.5kg'),

('1021','Tiago','Fone','Acessorios','2025-02-11','BRASIL','2','200','NULL','200g'),
('1022','Tiago','Fone','Acessórios','2025-02-11','BR','2','200','','0.2kg'),

('1023','Sandra','Notebook','Eletrônicos','2025-02-12','Brazil','1','NULL','10%','2kg'),
('1024','Sandra','Notebook','Eletrônicos','12/02/2025','Brazil','1','','0.1','2000g'),

('1025','Victor','Celular','Eletronicos','2025-02-13','BR','1','2500','-5%','0.2kg'),
('1026','Victor','Celular','Eletrônicos','13/02/2025','Brasil','1','2500','-0.05','200g'),

('1027',' ','Mousepad','Perifericos','2025-02-14','Brazil','1','50','5%','50g'),
('1028',NULL,'Mousepad','Periféricos','14/02/2025','BR','1','50','0.05','0.05kg'),

('1029','Lucas','HD Externo','Acessorios','2025-02-15','BR','2','500','5 %','300 g'),
('1030','Lucas','HD Externo','Acessórios','15/02/2025','Brazil','2','500.00','0.05','0.3kg'),

('1031','Bianca','Webcam','Perifericos','2025-02-16','BR','1','350','N/A','150g'),
('1032','Bianca','Webcam','Periféricos','16/02/2025','Brasil','1','350','0','0.15kg');


select * from treino_limpeza.raw.vendas_sujas2;

-- sta1 = remover duplicatas perfeitas
create or replace table sta1 as(
    select distinct order_id, customer_name, product, category, order_date, country, quantity, price, discount, weight
    from treino_limpeza.raw.vendas_sujas2
    order by order_id
);

-- sta2 padronizar tipos de colunas de string para date / number
-- order_date => date
-- quantity, price, discount, weight => number
-- padronizar numeros: 4.500,00 / 2300,50
create or replace table sta2 as (
    select  order_id as id, 
            customer_name as name, 
            product, 
            category, 
            country,
            coalesce(
            try_to_date(order_date, 'YYYY/MM/DD'),
            try_to_date(order_date, 'YYYY.MM.DD'),
            try_to_date(order_date, 'YYYY-MM-DD'),
            try_to_date(order_date, 'DD/MM/YYYY'),
            try_to_date(order_date, 'DD.MM.YYYY'),
            try_to_date(order_date, 'DD-MM-YYYY')        
            ) as date,
            try_to_number(quantity) as quantity,
            try_to_number(case 
                            when price like '%.%' and price like '%,%' then replace(replace(price,'.',''),',','.')
                            when price like '%,%' then replace(price,',','.')
                            when price like '%.%' and regexp_like(price, '^[0-9]{1,3}(\\.[0-9]{3})+$') then replace(price, '.', '')
                          else price end) as price,
            try_to_number(replace(discount,'%',''))/ case when discount like '%-%%' escape '-' then 100 else 1 end as discount,
            try_to_number(replace(replace(weight,'kg',''),'g','')) * case when  weight like '%kg'then 1000 else 1 end as weight
    from sta1         
);

-- padronizar colunas strings initcap + trim
create or replace table sta3 as (
    select  trim(id) as id,
            initcap(trim(name)) as name,
            initcap(trim(product)) as product,
            initcap(trim(category)) as category,
            initcap(trim(country)) as country,
            date, quantity, price, discount, weight
    from sta2
);

-- padronizar nulls
create or replace table sta4 as (
    select  id,
            case when lower(name) in ('null', 'none', '', 'n/a') then Null else name end as name,
            case when lower(product) in ('null', 'none', '', 'n/a') then Null else product end as product,
            case when lower(category) in ('null', 'none', '', 'n/a') then Null else category end as category,
            case when lower(country) in ('null', 'none', '', 'n/a') then Null else country end as country,
            case when lower(date) in ('null', 'none', '', 'n/a') then Null else date end as date,
            case when lower(quantity) in ('null', 'none', '', 'n/a') then Null else quantity end as quantity,
            case when lower(price) in ('null', 'none', '', 'n/a') then Null else price end as price,
            case when lower(discount) in ('null', 'none', '', 'n/a') then Null else cast(discount as decimal(10,2)) end as discount,
            case when lower(weight) in ('null', 'none', '', 'n/a') then Null else weight end as weight
    from sta3
);

-- padronizar product / category / country / colunas numericas negativas
-- category: Acessorios - Acessórios / Eletronicos - Eletrônicos / Escritorio - Escritório / Moveis - Móveis / Perifericos - Periféricos
-- country: 'Br' e 'Brazil' => 'Brasil'
-- colunas numericas negativas => Null
-- product: Camera/Tripe => Câmera/Tripé
create or replace table sta5 as (
    select  id, name, 
            case 
                when product = 'Camera' then 'Câmera'
                when product = 'Tripe' then 'Tripé'
                else product
            end as product,
            case
                when category = 'Acessorios' then 'Acessórios'
                when category = 'Eletronicos' then 'Eletrônicos'
                when category = 'Escritorio' then 'Escritório'
                when category = 'Moveis' then 'Móveis'
                when category = 'Perifericos' then 'Periféricos'
                else category
            end as category,
            case when lower(country) in ('br', 'brazil') then 'Brasil' else country end as country,
            date,
            case when quantity < 0 then Null else quantity end as quantity,
            case when price < 0 then Null else price end as price,
            case when discount < 0 then Null else discount end as discount,
            case when weight < 0 then Null else weight end as weight         
    from sta4
);

-- sta6 + sta7 encontrar melhores linhas para remover duplicatas
create or replace table sta6 as (
    select  id, name, product, category, country, date, quantity, price, discount, weight,
            (case when name is not null then 1 else 0 end +
             case when product is not null then 1 else 0 end +
             case when category is not null then 1 else 0 end +
             case when country is not null then 1 else 0 end +
             case when date is not null then 1 else 0 end +
             case when quantity is not null then 1 else 0 end +
             case when price is not null then 1 else 0 end +
             case when discount is not null then 1 else 0 end +
             case when weight is not null then 1 else 0 end
            ) as score
    from sta5
);

create or replace table sta7 as (
    select  id, name, product, category, country, date, quantity, price, discount, weight, score,
            row_number()over(partition by name,product, category, country, date order by score desc) as rn
    from sta6
);

-- filtrar pelo row number = 1 - pegando melhores linhas
create or replace table sta8 as (
    select id, name, product, category, country, date, quantity, price, discount, weight
    from sta7 
    where rn = 1 and weight <> 0 
    order by id
);

-- filtro final removendo nulls duplicados 
create or replace table sta9 as (
    select id, name, product, category, country, date, quantity, price, discount, weight
    from sta8
    where date is not Null and name is not Null
    order by id
);
