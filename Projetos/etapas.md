# Checklist cleaning

## 1️⃣ Exploração inicial da base
- Checar tipos de colunas (numéricas, categóricas, booleanas, datas)
- Identificar colunas nulas ou irrelevantes para o BI final
- Colunas numéricas: calcular min, max, média, desvio padrão
- Colunas categóricas: distinct count e distribuição (value_counts)
- Verificar percentual de nulos por coluna
- Registrar observações e anotações sobre problemas potenciais

## 2️⃣ Remoção inicial de duplicatas
- Remover registros totalmente idênticos em todas as colunas
- Objetivo: reduzir volume e otimizar o processamento
- Registrar quantidade de duplicatas removidas

## 3️⃣ Padronização de colunas
- Corrigir tipos de dados errados (ex.: string → int ou datetime)
- Renomear colunas para snake_case, remover espaços e caracteres especiais
- Padronizar letras maiúsculas/minúsculas
- Padronizar valores nulos (null, NULL, None, NaN, "")
- Padronizar strings categóricas (abreviações, erros de digitação)
- Padronizar datas e formatos (YYYY-MM-DD)
- Opcional: remover colunas totalmente vazias ou irrelevantes

## 4️⃣ Tratamento de nulos
- Avaliar quantidade de nulos e impacto no BI
- Estratégias:
  - Preencher com média, moda ou valor default
  - Remover linhas irrelevantes
- Registrar no log o que foi feito e por qual motivo

## 5️⃣ Remoção secundária de duplicatas
- Remover duplicatas que apareceram após padronização
- Registrar quantidade removida e colunas consideradas

## 6️⃣ Normalização para BI
- Valores numéricos: escalar ou padronizar (0–1 ou z-score)
- Unidades: padronizar para a unidade usada em dashboards (g → kg, ml → L)
- Datas: criar colunas auxiliares (ano, mês, trimestre, dia_semana)
- Categóricos: transformar em códigos numéricos ou dummies (Sim/Não → 1/0)
- Strings: remover espaços extras, padronizar capitalização e abreviações
- Métricas derivadas: criar indicadores para BI (ex.: receita média por cliente, taxa de conversão)
