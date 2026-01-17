# Limpeza de Dados 2 - Dataset - 17-01-2026

---

## 🔹 Antes e Depois
Visualização do impacto da limpeza de dados na tabela bruta versus a tabela final padronizada.

### Tabela Bruta (Raw)
![Raw Table](./images/02Raw_Table.png)

### Tabela Final (Cleaned)
![Final Table](./images/02Final_Table.png)

---

## 🔹 Padrão de Limpeza de Dados Utilizado

Neste segundo projeto, a complexidade foi elevada para tratar inconsistências severas de formatos e duplicatas parciais. Foi implementada uma lógica de **Scoring (Pontuação de Qualidade)** para garantir a integridade da desduplicação e sempre manter a informação mais rica.

### 1. Entendimento da Base
- Identificação de múltiplos formatos de data (`/`, `.`, `-`) e ordens variadas (DMY vs YMD).
- Verificação de preços que misturam padrões brasileiros e americanos de separadores.
- Presença de strings "sujas" que representam valores nulos (ex: `'None'`, `'N/A'`).

### 2. Remoção Inicial de Duplicatas
- Utilização de `DISTINCT` para eliminar registros 100% idênticos em todas as colunas, otimizando o processamento das próximas etapas.

### 3. Padronização Avançada de Tipos
- **Datas:** Uso da função `COALESCE` para testar sequencialmente 6 formatos diferentes de data.
- **Preços:** Lógica condicional com `REGEXP` para distinguir separadores de milhar e decimal.
- **Peso:** Conversão unificada de unidades mistas (`kg` e `g`) para um padrão numérico único.

### 4. Normalização Textual e de Nulos
- Aplicação de `INITCAP` e `TRIM` para consistência visual.
- Conversão de placeholders de texto vazios ou inválidos para o valor `NULL` real do banco de dados.

### 5. Lógica de Scoring e Deduplicação (Melhor Linha)
- Criação de um sistema de pontuação por linha: quanto mais colunas preenchidas, maior o `score`.
- Uso de `ROW_NUMBER` com `PARTITION BY` para agrupar transações repetidas e eleger a "melhor versão" (a mais completa) para o BI final.

---

## Inserção de Dados
*(Trecho resumido para visualização do problema)*
```sql
INSERT INTO treino_limpeza.raw.vendas_sujas2 VALUES
('1001',' João Silva ','Notebook','Eletronicos','2025-02-01','BR','1','4500','10%','2kg'),
('1002','Maria','Notebook','Eletrônicos','01/02/2025','Brasil','2','4.500,00','0.1','2000 g'),
('1005','Carlos','Monitor','Moveis','invalid','Brazil','1','1200','NULL','3kg'),
('1031','Bianca','Webcam','Perifericos','2025-02-16','BR','1','350','N/A','150g');
```



## 01 - STA1: Remoção de Duplicadas Exatas
```sql
CREATE OR REPLACE TABLE sta1 AS (
    SELECT DISTINCT 
        order_id, customer_name, product, category, order_date, country, quantity, price, discount, weight
    FROM treino_limpeza.raw.vendas_sujas2
    ORDER BY order_id
);
```

Aplicação simples do `DISTINCT` para eliminar linhas onde absolutamente todas as colunas são idênticas.

---

## 02 - STA2: Padronização Avançada de Tipos
```sql
CREATE OR REPLACE TABLE sta2 AS (
    SELECT  order_id AS id, 
            customer_name AS name, 
            product, category, country,
            COALESCE(
                TRY_TO_DATE(order_date, 'YYYY/MM/DD'),
                TRY_TO_DATE(order_date, 'YYYY.MM.DD'),
                TRY_TO_DATE(order_date, 'YYYY-MM-DD'),
                TRY_TO_DATE(order_date, 'DD/MM/YYYY'),
                TRY_TO_DATE(order_date, 'DD.MM.YYYY'),
                TRY_TO_DATE(order_date, 'DD-MM-YYYY')        
            ) AS date,
            TRY_TO_NUMBER(quantity) AS quantity,
            TRY_TO_NUMBER(CASE 
                            WHEN price LIKE '%.%' AND price LIKE '%,%' THEN REPLACE(REPLACE(price,'.',''),',','.')
                            WHEN price LIKE '%,%' THEN REPLACE(price,',','.')
                            WHEN price LIKE '%.%' AND REGEXP_LIKE(price, '^[0-9]{1,3}(\\.[0-9]{3})+$') THEN REPLACE(price, '.', '')
                          ELSE price END) AS price,
            TRY_TO_NUMBER(REPLACE(discount,'%','')) / CASE WHEN discount LIKE '%-%%' ESCAPE '-' THEN 100 ELSE 1 END AS discount,
            TRY_TO_NUMBER(REPLACE(REPLACE(weight,'kg',''),'g','')) * CASE WHEN weight LIKE '%kg' THEN 1000 ELSE 1 END AS weight
    FROM sta1         
);
```

- **Datas:** Uso da função `COALESCE` para testar 6 formatos diferentes de data sequencialmente. O primeiro que funcionar é mantido.
- **Preço:** Lógica condicional para tratar separadores de milhar e decimal (ex: `4.500,00` vs `4500.00`).
- **Peso:** Conversão unificada para gramas.

---

## 03 - STA3: Padronização Textual
```sql
CREATE OR REPLACE TABLE sta3 AS (
    SELECT  TRIM(id) AS id,
            INITCAP(TRIM(name)) AS name,
            INITCAP(TRIM(product)) AS product,
            INITCAP(TRIM(category)) AS category,
            INITCAP(TRIM(country)) AS country,
            date, quantity, price, discount, weight
    FROM sta2
);
```

Limpeza de espaços em branco (`TRIM`) e ajuste de capitalização (`INITCAP`) para nomes próprios, produtos e categorias.

---

## 04 - STA4: Padronização de Nulos
```sql
CREATE OR REPLACE TABLE sta4 AS (
    SELECT  id,
            CASE WHEN LOWER(name) IN ('null', 'none', '', 'n/a') THEN NULL ELSE name END AS name,
            CASE WHEN LOWER(product) IN ('null', 'none', '', 'n/a') THEN NULL ELSE product END AS product,
            CASE WHEN LOWER(category) IN ('null', 'none', '', 'n/a') THEN NULL ELSE category END AS category,
            CASE WHEN LOWER(country) IN ('null', 'none', '', 'n/a') THEN NULL ELSE country END AS country,
            date, quantity, price, 
            CASE WHEN LOWER(discount) IN ('null', 'none', '', 'n/a') THEN NULL ELSE CAST(discount AS DECIMAL(10,2)) END AS discount,
            weight
    FROM sta3
);
```

Transforma strings que representam nulidade (ex: "None", "N/A", "null") em valores `NULL` reais para permitir a contagem correta de qualidade no próximo passo.

---

## 05 - STA5: Regras de Negócio e Correções Específicas
```sql
CREATE OR REPLACE TABLE sta5 AS (
    SELECT  id, name, 
            CASE 
                WHEN product = 'Camera' THEN 'Câmera'
                WHEN product = 'Tripe' THEN 'Tripé'
                ELSE product
            END AS product,
            CASE
                WHEN category = 'Acessorios' THEN 'Acessórios'
                WHEN category = 'Eletronicos' THEN 'Eletrônicos'
                WHEN category = 'Escritorio' THEN 'Escritório'
                WHEN category = 'Moveis' THEN 'Móveis'
                WHEN category = 'Perifericos' THEN 'Periféricos'
                ELSE category
            END AS category,
            CASE WHEN LOWER(country) IN ('br', 'brazil') THEN 'Brasil' ELSE country END AS country,
            date,
            CASE WHEN quantity < 0 THEN NULL ELSE quantity END AS quantity,
            CASE WHEN price < 0 THEN NULL ELSE price END AS price,
            CASE WHEN discount < 0 THEN NULL ELSE discount END AS discount,
            CASE WHEN weight < 0 THEN NULL ELSE weight END AS weight          
    FROM sta4
);
```

- Tradução e unificação de países ('Br' e 'Brazil' -> 'Brasil').
- Correção ortográfica e acentuação de produtos e categorias.
- Invalidação de números negativos em colunas quantitativas (convertendo para `NULL`).

---

## 06 e 07 - STA6/STA7: Deduplicação Inteligente (Scoring)
```sql
CREATE OR REPLACE TABLE sta6 AS (
    SELECT  *,
            (CASE WHEN name IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN product IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN category IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN country IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN date IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN quantity IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN price IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN discount IS NOT NULL THEN 1 ELSE 0 END +
             CASE WHEN weight IS NOT NULL THEN 1 ELSE 0 END
            ) AS score
    FROM sta5
);

CREATE OR REPLACE TABLE sta7 AS (
    SELECT  *,
            ROW_NUMBER() OVER(PARTITION BY name, product, category, country, date ORDER BY score DESC) AS rn
    FROM sta6
);
```

- **Score:** Cria uma pontuação baseada em quantas colunas válidas a linha possui.
- **Rank:** Agrupa linhas que parecem ser a mesma transação e ordena pelo `score` decrescente. A linha mais completa recebe `rn = 1`.

---

## 08 e 09 - STA8/STA9: Filtros Finais e Integridade
```sql
CREATE OR REPLACE TABLE sta9 AS (
    SELECT id, name, product, category, country, date, quantity, price, discount, weight
    FROM sta7 
    WHERE rn = 1 
      AND weight <> 0 
      AND date IS NOT NULL 
      AND name IS NOT NULL
    ORDER BY id
);
```

Aplicação final das regras de negócio, removendo registros que, mesmo após a limpeza, não possuem qualidade suficiente para análise (ex: registros sem data ou sem nome do cliente).

---

## 🔹 Resumo de Técnicas Utilizadas

1. **COALESCE para Datas:** Essencial para bases com preenchimento manual onde o padrão de data varia entre linhas.
2. **Regex para Preços:** `REGEXP_LIKE` ajuda a garantir que a conversão decimal não ignore os pontos de milhar.
3. **Row Scoring & Window Functions:** Técnica avançada para resolver conflitos de dados, garantindo que o dataset final contenha a informação mais completa disponível.
4. **Apache Airflow:** Ferramenta recomendada para a orquestração futura deste pipeline de dados.
