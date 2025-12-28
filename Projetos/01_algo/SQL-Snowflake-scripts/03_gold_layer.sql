use database sql_challenges;

-- criando schema gold para separar projeto final
create schema if not exists gold;

-- criar a tabela final na camada gold
create or replace table sql_challenges.gold.fact_layoffs_clean as
select 
    company,
    industry,
    location,
    country,
    stage,
    layoff_date,
    total_laid_off,
    percentage_laid_off,
    funds_raised_millions
from sql_challenges.public.silver_layoffs_conformed
where total_laid_off is not null 
   or percentage_laid_off is not null
order by layoff_date desc;
