# Limpeza de Dados - Dataset01

## 1️⃣ USE ROLE e Setup do Database/Schema
**Legenda:**  
Define o **role de administração** e o **warehouse** para execução das queries. Cria o **database `treino_limpeza`** e o **schema `raw`**, preparando o ambiente para os dados.

---

## 2️⃣ Criação da Tabela `vendas_sujas` e Inserção de Dados
**Legenda:**  
Cria a tabela **bruta**, com todas as colunas como `STRING`. Insere dados simulando **problemas reais**: duplicatas, nomes nulos, datas inconsistentes, unidades diferentes, porcentagens e valores numéricos como strings.

---

## 3️⃣ STA1 – Remoção de Duplicadas Exatas
**Legenda:**  
Cria uma nova tabela **sem duplicadas perfeitas** (`SELECT DISTINCT *`). Esse passo limpa **registros 100% iguais** antes de qualquer transformação.

---

## 4️⃣ STA2 – Padronização de Tipos
**Legenda:**  
Converte as colunas para os **tipos corretos**:  
- `order_date` → DATE  
- `quantity` → NUMBER  
- `price` → DECIMAL  
- `discount` → DECIMAL (removendo `%`)  
- `weight` → DECIMAL (converte kg → g)  

Essa etapa garante **consistência numérica e de datas**.

---

## 5️⃣ STA3 – Limpeza de Valores Negativos
**Legenda:**  
Substitui números negativos em `quantity`, `price`, `discount` e `weight` por `NULL`. Isso evita valores que não fazem sentido na análise, como quantidades ou descontos negativos.

---

## 6️⃣ STA4 – Padronização Textual
**Legenda:**  
Aplica **`TRIM`** para remover espaços extras e **`INITCAP`** para padronizar maiúsculas/minúsculas em `name`, `product`, `category` e `country`. Facilita buscas e comparação de strings.

---

## 7️⃣ STA5 – Padronização de Valores de Referência
**Legenda:**  
- Converte `'None'`, `'null'`, `'N/A'` → `NULL` em `name`  
- Unifica `country` (`Br`/`Brasil` → `Brazil`)  
- Corrige categorias escritas de forma inconsistente ou sem acento  

Essa etapa garante **padronização semântica** e prepara a tabela para análise final.

---

## 8️⃣ Hash Final – Conferência de Duplicadas
**Legenda:**  
Gera um **hash para cada linha** (`MD5(CONCAT_WS('/', name, product, price, weight, date))`) e conta duplicadas exatas. Permite identificar registros **idênticos** após todas as transformações e confirma que a limpeza foi bem-sucedida.

---

## 9️⃣ Tabela Final Pronta
**Legenda:**  
Tabela `sta5` finalizada, com todos os dados limpos, tipos corretos, textos padronizados e duplicadas removidas. Pronta para análises e relatórios.

