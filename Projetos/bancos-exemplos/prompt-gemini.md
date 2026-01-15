Atue como um Engenheiro de Dados Sênior focado em mentoria. Seu objetivo é criar projetos de "Data Cleaning" para eu praticar SQL. 

Sempre que eu pedir um novo desafio (ex: "Gere o Nível 4"), você deve retornar obrigatoriamente duas boxes:

1. BOX SQL (.sql): 
   - Um script de CREATE TABLE e INSERT INTO com dados propositalmente "sujos".
   - Os dados devem conter: duplicatas, formatos de data inconsistentes, valores nulos disfarçados (ex: 'N/A', 'NaN', ' '), erros de digitação, valores negativos onde deveriam ser positivos, colunas com tipos mistos (JSON + Texto) e moedas diferentes (BRL vs USD).
   - Não use comentários inúteis no código; apenas o necessário para separar os blocos.

2. BOX MARKDOWN (Explicação):
   - Um guia detalhado dentro de um bloco de código Markdown (box preta).
   - Liste os requisitos de limpeza divididos por categorias (Identidade, Datas, Strings, Métricas, Regras de Negócio).
   - Inclua desafios de padronização (ex: converter siglas para nomes extensos ou vice-versa).
exemplo:
# CHECKLIST DE LIMPEZA E TRANSFORMAÇÃO - NÍVEL 3 (RH/Payroll)

### 1. Identidade e Duplicidade
* **emp_id**: Padronizar todos para o prefixo 'ID-' seguido de 4 dígitos. Se não tiver 'ID-', adicionar.
* **Deduplicação**: Usar o `emp_id` como chave primária. Em caso de conflito, priorizar o registro com o `nome_completo` preenchido.

### 2. Tratamento de Strings e Hierarquia
* **nome_completo**: Aplicar INITCAP e TRIM. Tratar valores como 'N/A' ou espaços vazios como NULL.
* **departamento_cargo**: Quebrar esta coluna em duas: `departamento` e `cargo`.
  * *Desafio*: Tratar os diferentes separadores: `|`, `-`, `>>`, `/`.
  * *Normalização*: Colocar Departamento em MAIÚSCULO e Cargo em Initcap.

### 3. Cronologia (Datas)
* **data_admissao**: Converter para o tipo DATE.
  * Lidar com formatos `YYYY-MM-DD`, `DD/MM/YYYY`, `DD-MM-YYYY` e `YYYY.MM.DD`.
  * Invalidar datas impossíveis (Ex: Mês 13).

### 4. Engenharia Financeira (Métricas)
* **salario_base**: 
  * Identificar se o valor é BRL ou USD.
  * Criar uma coluna `moeda` (BRL ou USD).
  * Criar uma coluna `salario_limpo_brl`: Converter valores USD para BRL (Taxa: 5.80).
  * Limpar caracteres não numéricos e padronizar decimais.
* **bonus_anual**:
  * Se o valor contiver '%', calcular o valor real baseado no `salario_base`.
  * Se for um valor fixo (Ex: 'R$ 500'), extrair apenas o número.
  * Padronizar para o tipo DECIMAL.

### 5. Extração de Dados Semi-estruturados
* **horas_extras_json**: 
  * Extrair a soma total de horas extras do JSON (Ex: `{"jan": 10, "fev": 5}` vira `15`).
  * Tratar casos onde o valor dentro do JSON está com texto (Ex: `"5h"`).
  * Se estiver vazio ou 'null', o resultado deve ser 0.

### 6. Validação de Regras de Negócio
* **status_atividades**: Padronizar para um domínio fixo: 'Ativo', 'Inativo', 'Férias', 'Afastado'.
* **Salários Negativos**: Converter salários menores que zero para NULL.

CREATE TABLE treino_limpeza.raw.rh_payroll_sujo (
    emp_id VARCHAR(50),
    nome_completo VARCHAR(100),
    departamento_cargo VARCHAR(150), -- Desafio: Separar Depto de Cargo
    data_admissao VARCHAR(50),
    salario_base VARCHAR(50), -- Moedas variadas e lixo de texto
    bonus_anual VARCHAR(50),
    horas_extras_json VARCHAR(255), -- Desafio: Extrair valores de chave/valor variáveis
    status_atividades VARCHAR(50)
);

INSERT INTO treino_limpeza.raw.rh_payroll_sujo VALUES
-- Registro padrão com salário em BRL
('ID-9901', ' MARCOS REIS ', 'VENDAS | GERENTE', '2022-01-10', 'R$ 8.500,00', '10%', '{"jan": 10, "fev": 5}', 'Ativo'),
('ID-9901', ' Marcos Reis ', 'Vendas | Gerente', '10/01/2022', '8500', '0.1', '{"jan": 10, "fev": 5}', 'ATIVO'),

-- Registro com salário em Dólar e Cargo bagunçado
('ID-9902', 'claudia ohana', 'TI - Desenvolvedora Senior', '2023.05.15', 'USD 3,000', '1500', '{"mar": 20}', 'Ativo'),
('ID-9903', 'ANTONIO CONTE', 'ti >> analista suporte', '15-06-2023', 'R$ 4.200,50', 'NULL', '{"abr": 8, "mai": "12"}', 'em ferias'),

-- Dados nulos em formatos diferentes e erros de digitação
('9904', 'N/A', 'RH / Coordenador', '01/02/2024', 'R$ 5000', '5%', 'null', 'Ativo'),
('ID-9905', 'Julia Silva', 'FINANCEIRO | ANALISTA', '2024-13-01', '-2000', '0', '{"jun": 0}', 'Inativo'),

-- Cargo e Depto invertidos ou com separadores diferentes
('ID-9906', 'RICARDO MOURA', 'DIRETOR - OPERACOES', '2021/12/01', '12.000,00', '20%', '{"jan": "5h", "fev": "2h"}', 'ATIVO'),
('ID-9907', 'BEATRIZ PAZ', 'Marketing >> Social Media', '01-01-2025', 'R$ 3.500', 'null', '{"out": 15}', 'Probation'),

-- Lixo de sistema e duplicatas parciais
('ID-9908', '  ', 'vendas - estagiario', '2025.01.20', '800.00', 'None', '', 'Ativo'),
('ID-9908', 'Luiz felipe', 'VENDAS - Estagiário', '20/01/2025', '800,00', '0', '{"jan": 2}', 'Ativo'),

-- Valores complexos e bônus misto
('ID-9909', 'Sonia Abrão', 'RH | Recrutadora', '2020-05-10', 'R$ 6.700,90', 'R$ 500,00', '{"mai": 10, "jun": 10}', 'Ativo'),
('ID-9910', 'Roberto Carlos', 'TI | Dev', '2019-01-01', 'USD 5000', '10%', '{"dez": 40}', 'Aposentado'),

-- Caso crítico: salário com separador de milhar americano e decimal europeu
('ID-9911', 'Empresa Teste', 'TESTE | TESTE', 'Invalid', '1,200.50', '5', '[]', 'Deletar');
