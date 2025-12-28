
use role accountadmin;
use database sql_challenges;

create schema if not exists sql_challenges.silver;

create or replace table sql_challenges.silver.silver_layoffs_conformed as
-- padronizar valores nulos e remover espaços em branco
with cte1_standarize1 as (
select
    case 
        when TRIM(Company) IN ('', 'null', 'NULL', 'Null') then NULL 
        else TRIM(Company) 
    end as Company,
    case 
        when TRIM(Location) IN ('', 'null', 'NULL', 'Null') then NULL 
        else TRIM(Location) 
    end as Location,
    case 
        when TRIM(Industry) IN ('', 'null', 'NULL', 'Null') then NULL 
        else TRIM(Industry) 
    end as Industry, 
    case 
        when TRIM(Stage) IN ('', 'null', 'NULL', 'Null') then NULL 
        else TRIM(Stage) 
    end as Stage,
    case 
        when TRIM(Country) IN ('', 'null', 'NULL', 'Null') then NULL 
        else TRIM(Country) 
    end as Country,
    try_cast(total_laid_off as int) as Total_Laid_Off, 
    try_cast(percentage_laid_off as float) as Percentage_Laid_Off,
    TRY_TO_DATE("DATE", 'MM/DD/YYYY') as Layoff_Date,
    try_cast(funds_raised_millions as int) as Funds_Raised_Millions
from SQL_CHALLENGES.BRONZE.STG_LAYOFFS_RAW
),
-- normalizar capitalização dos textos
cte2_standarize2 as (
    select
        initcap(Company) as Company,
        initcap(Location) as Location,
        initcap(Industry) as Industry,
        initcap(Country) as Country,
        upper(Stage) as Stage,
        Total_Laid_Off,
        Percentage_Laid_Off,
        Layoff_Date,
        Funds_Raised_Millions       
    from cte1_standarize1
),

cte3_imputation as (
    select 
        Company, Location, Stage, Total_Laid_Off, 
        Percentage_Laid_Off, Layoff_Date, Funds_Raised_Millions,
-- ajustando United States. escrito errado
        case
            when Country = 'United States.' then 'United States'
            else Country
        end as Country,
-- ajuste de Industry (Unificando Crypto e preenchendo nulos)
        case
            when Company = 'Airbnb' then 'Travel'
            when Company = 'Carvana' then 'Transportation'
            when Company = 'Juul' then 'Consumer'
            when Industry in ('Crypto Currency', 'Cryptocurrency') then 'Crypto'
            else Industry 
        end as Industry
    from cte2_standarize2
),
-- remover duplicates
cte4_deduplicate as (
    select  *,
            row_number() over(partition by Company, Location, Stage, Total_Laid_Off, Percentage_Laid_Off, Layoff_Date, Funds_Raised_Millions, Country, Industry order by Company, Layoff_Date) as rn
    from cte3_imputation
)
select * exclude rn
from cte4_deduplicate
where rn = 1

