USE ROLE ACCOUNTADMIN;

-- criar tabelas com varchar para nao ter erro
CREATE OR REPLACE TABLE SQL_CHALLENGES.BRONZE.STG_LAYOFFS_RAW (
    company VARCHAR,
    location VARCHAR,
    industry VARCHAR,
    total_laid_off VARCHAR, 
    percentage_laid_off VARCHAR,
    date VARCHAR,
    stage VARCHAR,
    country VARCHAR,
    funds_raised_millions VARCHAR
);

-- teste inicial
SELECT * FROM SQL_CHALLENGES.BRONZE.STG_LAYOFFS_RAW LIMIT 10;
