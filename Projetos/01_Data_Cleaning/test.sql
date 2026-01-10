### 1. Padronização de valores nulos
  - Transformar valores inconsistentes ou placeholders em `NULL`:
  
CASE 
    WHEN coluna IN ('', 'None', 'null', 'NULL', 'N/A') THEN NULL 
    ELSE coluna 
END AS coluna

### 2. Padronização de texto
  - Remover espaços extras e capitalizar corretamente:

INITCAP(TRIM(coluna)) AS coluna

### 3. Remoção de duplicadas
  - Remover linhas completamente iguais:
  
SELECT DISTINCT * FROM tabela

### 4. Conversão de tipos
  - Converter colunas para tipos adequados:
  
TRY_TO_NUMBER(coluna) AS coluna_int
TRY_TO_DECIMAL(coluna) AS coluna_decimal
TRY_TO_DATE(coluna) AS coluna_date

### 5. Tratamento de datas inconsistentes
  - Padronizar diferentes formatos de datas para um único padrão:
  
TRY_TO_DATE(REPLACE(REPLACE(order_date, '/', '-'), '.','-')) AS date



