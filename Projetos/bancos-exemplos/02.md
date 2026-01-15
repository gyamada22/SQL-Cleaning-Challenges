# REQUISITOS DE LIMPEZA - NÍVEL 2 (Logística)

1. Identificadores (id_envio)
   - Padronização: Tudo em maiúsculo (ex: TRK-001).
   - Limpeza: TRIM (remover espaços início/fim).
   - Duplicatas: Resolver IDs repetidos (definir lógica de desempate, ex: manter o mais recente ou mais completo).

2. Datas (data_pedido)
   - Formato final: DATE (YYYY-MM-DD).
   - Tratamento: Resolver ambiguidade DD/MM vs MM/DD.
   - Erros: Converter 'Invalid Date', 'NaN' e vazios para NULL.

3. JSON e Texto (cliente_info)
   - Desafio: Coluna híbrida (contém JSON válido misturado com texto livre).
   - Objetivo: Criar duas colunas novas -> 'cliente_nome' e 'cliente_email'.
   - Limpeza: Remover caracteres residuais da extração.

4. Rota (rota)
   - Separação: Criar colunas 'origem' e 'destino'.
   - Delimitadores: Tratar múltiplos separadores (>, -, ->, para, /).
   - Normalização: Padronizar estados (ex: 'Rio de Janeiro' virar 'RJ', 'São Paulo' virar 'SP').

5. Dimensões (dimensoes_cm)
   - Parsing: Extrair 3 medidas (Altura, Largura, Profundidade).
   - Unidade: Normalizar tudo para cm (atenção aos registros em 'm').
   - Cálculo: Gerar coluna 'volume_m3' (metros cúbicos).

6. Métricas (peso_bruto e custo_frete)
   - Peso: Normalizar para KG (converter gramas 'g' -> 'kg').
   - Custo: Remover símbolos (R$, USD, U$).
   - Câmbio: Se a moeda for Dólar, converter para Real (taxa fixa ex: 5.5).
   - Numérico: Padronizar separador decimal (resolver conflito 1.500,00 vs 1500.00) e tratar negativos.

7. Status (status_entrega)
   - Padronização: Initcap (Primeira Maiúscula) e TRIM.
