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


select * from treino_limpeza.raw.vendas_sujas;

select top 100 * from treino_limpeza.raw.vendas_sujas;

with qwe as (


select count(*) cnt ,order_id  from treino_limpeza.raw.vendas_sujas group by order_id having count(*) > 1
)
select cnt from qwe where cnt > 1

-- STA1 = remover linhas duplicadas exatas
create or replace table sta1 as (
    select distinct * 
    from treino_limpeza.raw.vendas_sujas 
)
-- VISUALIZAR STA1
select * from sta1 order by order_id



-- STA2 = arrumar type das colunas
create or replace table sta2 as (
    select  order_id as id,
            customer_name as name,
            product,
            category,
-- Tratamento de data (para todas possibilidades)
            try_to_date(replace(replace(order_date, '/', '-'), '.','-')) date,
            country,
            try_to_number(quantity) as quantity,
            try_to_decimal(price) price,
-- Remove o símbolo '%' da coluna, converte para decimal, 
-- Divide por 100 se era percentual, e garante 2 casas decimais
            cast(try_to_decimal(replace(discount,'%',''),10,2) / case when discount like '%\%%' then 100 else 1 end as decimal(10,2)) as discount,
-- Remove as unidades 'kg' e 'g'
-- Converte o valor limpo para decimal (TRY_TO_DECIMAL)
-- Multiplica por 1000 se era kg, mantendo g como base
            try_to_decimal(replace(replace(lower(weight),'kg',''),'g',''))* case when lower(weight) like '%kg' then 1000 else 1 end as weight
    from sta1
)

-- VISUALIZAR STA2
select * from sta2 order by id



-- STA3 padronizar colunas numericas de negativo para Null
create or replace table sta3 as (
    select  id, name, product, category, date, country,
            case when quantity < 0 then Null else quantity end as quantity,
            case when price < 0 then Null else price end as price,
            case when discount < 0 then Null else discount end as discount,
            case when weight < 0 then Null else weight end as weight
    from sta2
)

-- VISUALIZAR STA3
select * from sta3 order by id


-- STA4 = initcap + trim
create or replace table sta4 as (
    select  id,date,quantity,price,discount,weight,
            initcap(trim(name)) as  name,
            initcap(trim(product)) as  product,
            initcap(trim(category)) as  category,
            initcap(trim(country)) as  country
    from sta3
)
select * from sta4 order by id
select distinct category from sta4 order by category -- arrumar coluna category + country

-- STA5 padronizar coluna category, country e name
create or replace table sta5 as (
    select  id, date, quantity, price, discount, weight, product, 
-- padronizar null da coluna name
            case
                when name in ('', 'None', 'null', 'NULL','N/A') then Null 
                else name
            end as name,
-- padronizar country Br/Brasil = Brazil
            case 
                when country = 'Br' then 'Brazil'
                when country = 'Brasil' then 'Brazil'
                else country
            end as country,
-- padronizar category escrita errada - sem acento
            case 
                when category = 'Acessorios' then 'Acessórios'
                when category = 'Eletrodomesticos' then 'Eletrodomésticos' 
                when category = 'Eletronicos' then 'Eletrônicos' 
                when category = 'Escritorio' then 'Escritório'
                when category = 'Moveis' then 'Móveis'
                when category = 'Perifericos' then 'Periféricos'
                else category
            end as category
    from sta4            
)

-- VISUALIZAR STA5
select * from sta5 order by id 


select distinct product from sta5 order by product -- coluna product ok

-- verificar com CTE se tem duplicados pós padronizaçao total
with qwe as (select name, product,price,weight, count(id) as  cnt from sta5 group by name, product,price,weight)
select cnt,name, product,price,weight from qwe where cnt > 1 order by name, product,price,weight
-- Ana, Carlos, Renata tem compras igausi porem uma das datas é null, nao da para confirmar
-- Sandra tem 2 compras iguais apesar de uma ter desconto, verificar com superior sobre 

select * from sta5 where name = 'Sandra'order by id 
  
-- usar row hash para confirmar se tem duplicatas finais
with hashes as (
    select  *,
            md5(concat_ws('/',name, product, price, weight, date)) as row_hash
    from sta5
)
select row_hash, count(*) as cnt from hashes group by row_hash having cnt > 1 order by cnt desc

--Tabela final pronta

select * from sta5 order by id
