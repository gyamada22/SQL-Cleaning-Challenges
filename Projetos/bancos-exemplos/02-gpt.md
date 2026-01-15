████████████████████████████████████████████████████████████████████████████
DATA CLEANING 3 — ROTEIRO DE LIMPEZA (NÍVEL MAIS DIFÍCIL)

Objetivo: transformar a base em uma tabela pronta para BI, totalmente
padronizada, confiável e comparável.

────────────────────────────────────────────────────────────────────────
1. DIAGNÓSTICO INICIAL
Você deve identificar:
- Quantos formatos de data existem
- Quantos tipos de escrita existem para:
  - Eletronicos / Eletrônicos
  - Esporte / Esportes
  - Educacao / Educação
  - Tenis / Tênis
  - Camera / Câmera
  - Acao / Ação
- Quantas variações de country:
  - BR, Brasil, BRASIL, Brazil, "Brazil "
- Quantas variações de peso:
  - g, kg, espaços, decimal
- Quais campos possuem:
  - "None", "NULL", "", "N/A", apenas espaços
- Onde aparecem valores negativos e zeros

────────────────────────────────────────────────────────────────────────
2. DUPLICATAS EXATAS
- Remover linhas 100% idênticas

────────────────────────────────────────────────────────────────────────
3. PADRONIZAÇÃO ESTRUTURAL
- Converter tipos:
  - order_id → inteiro
  - quantity → inteiro
  - price → decimal
  - discount → decimal
  - weight → decimal
  - date → date real

- Datas inválidas ("invalid") → NULL
- Converter todos os formatos para um padrão único

────────────────────────────────────────────────────────────────────────
4. PADRONIZAÇÃO SEMÂNTICA

Country:
- Tudo deve virar: Brazil

Category:
- Eletronicos → Eletrônicos  
- Esporte / Esportes → Esporte  
- Educacao → Educação  
- Eletrodomesticos → Eletrodomésticos  
- Perifericos → Periféricos  

Product:
- Smartwatch / Smart Watch  
- Tenis / Tênis  
- Camera de Acao / Câmera de Ação  
- Fone / Headphone (decidir padrão único)

Customer_name:
- "" → NULL  
- "None" → NULL  
- "NULL" → NULL  
- Apenas espaços → NULL  
- Trim geral

────────────────────────────────────────────────────────────────────────
5. NORMALIZAÇÃO NUMÉRICA

Price:
- "1.200,00" → 1200.00  
- "3.500,00" → 3500.00  

Discount:
- "15%" → 0.15  
- "10 %" → 0.10  
- "0.15" → 0.15  
- Negativo → NULL  
- Texto → NULL  

Weight:
Unidade final: KG

- 150 g → 0.15  
- 18000 g → 18  
- 0.9kg → 0.9  
- 120 g → 0.12  

────────────────────────────────────────────────────────────────────────
6. REGRAS DE VALIDADE

Quantity:
- Negativa → NULL  
- Zero → decidir regra de negócio  

Price:
- Negativo → NULL  

Discount:
- < 0 → NULL  
- > 1 → inválido  

Weight:
- Negativo → NULL  

────────────────────────────────────────────────────────────────────────
7. DUPLICATAS LÓGICAS
Após padronização, remover registros que tenham:
- Mesmo nome
- Mesmo produto
- Mesma data
- Mesmo preço
- Mesmo peso

────────────────────────────────────────────────────────────────────────
8. CHECKLIST FINAL
- Country apenas "Brazil"
- Datas válidas
- Categories 100% padronizadas
- Pesos todos em KG
- Descontos entre 0 e 1
- Quantidade não negativa
- Sem duplicatas
- Sem lixo textual

Esse banco já simula sujeira de marketplace real e é excelente para
Data Cleaning de nível intermediário/avançado.
████████████████████████████████████████████████████████████████████████████
