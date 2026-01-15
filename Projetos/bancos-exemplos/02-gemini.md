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
