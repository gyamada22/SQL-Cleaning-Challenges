Quero que você crie um mini-projeto de Data Cleaning com as seguintes características:

1️⃣ Banco de dados em SQL:
- Deve ser um INSERT INTO para uma tabela, por exemplo `treino_limpeza.raw.vendas_sujasX`.
- Entre 25 e 40 registros, para ser grande o suficiente para treinar.
- Adicione **variedade e “sujeira” realista**, incluindo:
  - Datas em vários formatos diferentes (YYYY-MM-DD, DD/MM/YYYY, YYYY/MM/DD, YYYY.MM.DD, DD-MM-YYYY) e algumas inválidas.
  - Países com siglas, erros de digitação, espaços extras, português/inglês (BR, br, Brasil, BRASIL, Brazil, "Brazil ").
  - Quantidade negativa, zero ou como string.
  - Preço com vírgula, ponto, separador de milhar, vazio, NULL, texto.
  - Desconto em %, decimal, negativo, vazio, texto, "N/A", etc.
  - Peso em g, kg, mg, com espaço, sem espaço, formato decimal, erro de unidade.
  - Nomes de clientes vazios, "None", "NULL", apenas espaços.
  - Categorias com erros de grafia ou acentuação.
  - Produtos com pequenas variações de escrita (por exemplo: "Camera" vs "Câmera").
  - Duplicatas exatas e duplicatas disfarçadas (mesmo produto, preço e peso, mas escrito diferente ou com espaços).
- O INSERT deve ser **válido para SQL** e pronto para ser executado.

2️⃣ Roteiro de limpeza em Markdown:
- Em uma **box separada**.
- Explicação **passo a passo do que deve ser feito**, não código.
- Cobrir as seguintes etapas, com observações de limpeza específicas:
  - Diagnóstico inicial: mapear formatos de dados, valores inválidos, variações de país, categoria, produto, peso, nome e desconto.
  - Remoção de duplicatas exatas.
  - Padronização estrutural: tipos de dados corretos, datas, preços, descontos, pesos.
  - Padronização semântica: country, category, product, customer_name.
  - Normalização numérica: price, discount, weight, unidades consistentes.
  - Regras de validade: quantity, price, discount, weight.
  - Remoção de duplicatas lógicas.
  - Checklist final: dataset pronto para BI.

3️⃣ Formato de entrega:
- **Uma box de código SQL** contendo apenas o INSERT do banco.
- **Uma box de Markdown** explicando o passo a passo do Data Cleaning.
- Tudo bem organizado e fácil de copiar para projeto de portfólio.

✅ Extra: varie sempre os tipos de sujeira e formatação de forma diferente dos exemplos anteriores, para criar novos desafios de limpeza.

exemplo:
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

INSERT INTO treino_limpeza.raw.vendas_sujas3 VALUES
('2001','  Bruno Lima ','Smartwatch','Eletronicos','2025-03-01','BR','1','1.200,00','15%','150 g'),
('2002','Bruno Lima','Smart Watch','Eletrônicos','01/03/2025','Brasil','1','1200.00','0.15','0.15kg'),

('2003','None','Bicicleta','Esporte','2025/03/02','brasil','-1','3500','5%','18kg'),
('2004','  ','Bicicleta','Esportes','02-03-2025','BR','1','3.500,00','0.05','18000 g'),

('2005','Laura','Tênis','Esporte','2025.03.03','Brazil ','2','450','10 %','900g'),
('2006','Laura ','Tenis','Esportes','03/03/2025','BR','2','450.00','0.1','0.9kg'),

('2007','Marcos','Mochila','Acessorios','invalid','BRASIL','1','200','NULL','500g'),
('2008','Marcos','Mochila','Acessórios','2025-03-04','Brazil','1','200','','0.5kg'),

('2009','Julia','Garrafa','Cozinha','2025-03-05','BR','3','35','0','250 g'),
('2010','Julia ','Garrafa','Cozinha','05/03/2025','Brasil','3','35.00','0%','0.25kg'),

('2011','Rafael','Câmera de Ação','Eletronicos','2025-03-06','BR','1','1800','-10%','120 g'),
('2012','Rafael','Camera de Acao','Eletrônicos','06/03/2025','Brazil','1','1.800,00','-0.1','0.12kg'),

('2013','Ana','Livro','Educacao','2025-03-07','BR','0','80','5%','300 g'),
('2014','Ana','Livro','Educação','07/03/2025','Brasil','1','80.00','0.05','0.3kg'),

('2015','NULL','Cafeteira','Eletrodomesticos','2025-03-08','BR','1','600','N/A','2kg'),
('2016','Pedro','Cafeteira','Eletrodomésticos','08/03/2025','Brazil','1','600.00','0','2000 g'),

('2017','Sofia','Headphone','Perifericos','2025/03/09','BR','1','300','5%','250g'),
('2018','Sofia','Fone','Periféricos','09/03/2025','Brasil','1','300.00','0.05','0.25kg'),

('2019','Lucas','Balança','Cozinha','2025-03-10','BR','1','150','10%','1kg'),
('2020','Lucas','Balança','Cozinha','10/03/2025','Brazil','1','150.00','0.1','1000 g'),

('2021','Beatriz','Tablet','Eletronicos','2025-03-11','BR','1','2500','5%','400 g'),
('2022','Beatriz','Tablet','Eletrônicos','11/03/2025','Brasil','1','2.500,00','0.05','0.4kg'),

('2023','Gustavo','Drone','Eletronicos','2025-03-12','BR','1','4500','20%','1.2kg'),
('2024','Gustavo','Drone','Eletrônicos','12/03/2025','Brazil','1','4.500,00','0.2','1200 g'),

('2025','  ','Mouse Gamer','Perifericos','2025-03-13','BR','2','180','5%','90g'),
('2026',NULL,'Mouse Gamer','Periféricos','13/03/2025','Brasil','2','180.00','0.05','0.09kg');
