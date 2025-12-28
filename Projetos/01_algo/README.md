🥈 Camada Silver: Limpeza e Padronização (Conformed)
Nesta etapa, os dados foram movidos da camada Bronze para a Silver. O objetivo principal foi transformar os dados brutos (onde tudo era texto) em uma tabela estruturada, tipada e pronta para análise, sem alterar a fonte original.

Principais Transformações Aplicadas:
Tipagem de Dados (Data Casting):

Conversão Numérica: Utilizei TRY_CAST nas colunas Total_Laid_Off, Percentage_Laid_Off e Funds_Raised_Millions. O TRY_CAST foi escolhido em vez do CAST tradicional para evitar erros de execução caso existissem valores não numéricos (como o texto 'NULL' ou 'N/A' vindo do CSV), convertendo-os automaticamente em nulos reais.

Tratamento de Datas: Usei TRY_TO_DATE para converter a coluna "DATE" (originalmente string no formato MM/DD/YYYY) para o formato de data padrão do Snowflake. Usei aspas duplas "DATE" para evitar conflitos com a palavra reservada do sistema.

Qualidade e Limpeza de Strings:

Remoção de Espaços: Apliquei TRIM() em todas as colunas de texto para eliminar espaços em branco acidentais no início ou fim das palavras.

Tratamento de Valores Vazios: Combinei NULLIF(..., '') para garantir que strings vazias fossem convertidas em valores NULL reais, facilitando filtros e cálculos de completude de dados.

Padronização Visual (Case Normalization): Utilizei a função INITCAP() nas colunas Company, Location e Country para garantir que nomes próprios sempre comecem com letra maiúscula, corrigindo inconsistências de digitação (ex: "google" ou "GOOGLE" -> "Google").

Arquitetura de Query (CTAs + CTEs):

Implementei a lógica utilizando CTEs (Common Table Expressions) para garantir que o código seja modular e legível.

A tabela foi criada usando o padrão CTAS (Create Table As Select), permitindo uma migração performática e segura dos dados da Bronze para a Silver.
