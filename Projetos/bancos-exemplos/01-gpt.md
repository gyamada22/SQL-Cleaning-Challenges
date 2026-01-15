████████████████████████████████████████████████████████████████████████████
DATA CLEANING 2 — ROTEIRO COMPLETO DE LIMPEZA (SEM CÓDIGO)
Objetivo: transformar uma base crua e inconsistente em uma tabela confiável
para uso em BI e análises.

────────────────────────────────────────────────────────────────────────
ETAPA 0 — ENTENDER A BASE (DIAGNÓSTICO)
Objetivo: mapear toda a sujeira antes de tocar nos dados.

Você deve identificar:
- Quais colunas deveriam ser numéricas mas estão como texto
- Quais colunas deveriam ser datas
- Quantos formatos de data existem
- Quais valores inválidos aparecem (NULL, None, N/A, "", espaços)
- Quantas variações existem para:
  - Country
  - Category
  - Product
  - Discount
  - Weight
  - Customer_name

Aqui você NÃO limpa nada.
Você apenas observa, mede, anota e entende o problema.

────────────────────────────────────────────────────────────────────────
ETAPA 1 — REMOÇÃO DE DUPLICATAS EXATAS
Objetivo: reduzir ruído no dataset.

O que remover:
- Linhas 100% idênticas em todas as colunas

O que manter:
- Linhas parecidas mas com escrita diferente
(Essas ficam para depois da padronização)

────────────────────────────────────────────────────────────────────────
ETAPA 2 — PADRONIZAÇÃO ESTRUTURAL
Objetivo: tornar o dataset tecnicamente utilizável.

Você precisa:
- Corrigir tipos de dados:
  - order_id → inteiro
  - quantity → inteiro
  - price → decimal
  - discount → decimal
  - weight → decimal
  - date → tipo date real

- Converter strings numéricas:
  - "4.500,00" → 4500.00
  - "2.500" → 2500
  - "" → NULL
  - "NULL" → NULL
  - "N/A" → NULL

- Datas:
  Identificar todos os formatos:
  - YYYY-MM-DD
  - DD/MM/YYYY
  - YYYY/MM/DD
  - YYYY.MM.DD
  - DD-MM-YYYY
  - Datas inválidas ("invalid") → NULL

────────────────────────────────────────────────────────────────────────
ETAPA 3 — PADRONIZAÇÃO SEMÂNTICA
Objetivo: garantir que palavras diferentes signifiquem a mesma coisa.

Country:
- BR, br, Brasil, BRASIL, Brazil, "Brazil " → Brazil

Category:
- Eletronicos → Eletrônicos
- Acessorios → Acessórios
- Moveis → Móveis
- Escritorio → Escritório
- Perifericos → Periféricos
- Camera → Câmera
- Tripe → Tripé

Product:
- Notebook / notebook
- Camera / Câmera
- Tripe / Tripé
- Remover espaços extras
- Padronizar capitalização

Customer_name:
- "" → NULL
- "None" → NULL
- "NULL" → NULL
- Apenas espaços → NULL
- Remover espaços antes/depois do texto

────────────────────────────────────────────────────────────────────────
ETAPA 4 — NORMALIZAÇÃO NUMÉRICA
Objetivo: tornar números comparáveis.

Price:
- Converter tudo para decimal real
- Valores vazios → NULL

Discount:
Você pode ter:
- "10%" → 0.10
- "5%" → 0.05
- "0.1" → 0.10
- "-5%" → inválido → NULL
- "N/A", "NULL", "" → NULL

Weight:
Escolher unidade final: KG

Converter:
- 2000g → 2
- 500g → 0.5
- 300g → 0.3
- 50g → 0.05
- 0.18kg → 0.18

────────────────────────────────────────────────────────────────────────
ETAPA 5 — REGRAS DE VALIDADE
Objetivo: garantir coerência lógica.

Quantity:
- Negativa → NULL
- Zero → decidir se mantém ou remove

Price:
- Negativo → NULL

Discount:
- < 0 → NULL
- > 1 → inválido

Weight:
- Negativo → NULL
- Valores absurdos → sinalizar

────────────────────────────────────────────────────────────────────────
ETAPA 6 — DUPLICATAS LÓGICAS
Objetivo: remover duplicatas disfarçadas.

Após toda a padronização:
Verificar registros com:
- Mesmo customer_name
- Mesmo product
- Mesma date
- Mesmo price
- Mesmo weight

Se tudo bater → é a mesma venda → manter apenas uma.

────────────────────────────────────────────────────────────────────────
ETAPA 7 — CHECKLIST FINAL DE QUALIDADE
Objetivo: garantir base pronta para BI.

Confirmar:
- Country contém apenas "Brazil"
- Categories 100% padronizadas
- Datas válidas ou NULL
- Pesos todos em KG
- Preços numéricos reais
- Descontos sempre entre 0 e 1
- Quantidade nunca negativa
- Sem duplicatas
- Sem lixo textual ("None", "NULL", "N/A", "")

Aqui nasce sua tabela final de produção para Power BI / Analytics.
████████████████████████████████████████████████████████████████████████████
