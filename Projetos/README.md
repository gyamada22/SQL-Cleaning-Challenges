# 📊 20 DATASETS "SUJOS" EM ORDEM DE DIFICULDADE

## 🎯 NÍVEL MÉDIO (1-7)

### 1. **Brazilian Houses to Rent**
- **Kaggle ID:** `rubenssjr/brasilian-houses-to-rent`
- **Problemas de limpeza:** 
  - Valores `hoa` e `property tax` como 0 ou missing
  - Coluna `floor` com valores como `'301'`, `'17'`, `'-'`
  - `animal` como `'acept'` vs `'not acept'`
  - Cidades abreviadas: `'SÃ£o Paulo'`, `'Rio de Janeiro'`
- **Tamanho:** ~50KB
- **Dificuldade:** 3/10

### 2. **Retail Sales Dataset**
- **Kaggle ID:** `manjeetsingh/retaildataset`
- **Problemas de limpeza:**
  - 3 tabelas separadas (features, sales, stores)
  - JOINs complexos com datas inconsistentes
  - Valores negativos em `Weekly_Sales`
  - Missing values em `Temperature`, `Fuel_Price`
  - Store types inconsistentes (`'A'`, `'a'`, `'A '`)
- **Tamanho:** ~300KB
- **Dificuldade:** 4/10

### 3. **US Accidents (2016-2023)**
- **Kaggle ID:** `sobhanmoosavi/us-accidents`
- **Problemas de limpeza:**
  - 47 colunas - muitas redundantes
  - Timezones diferentes (`'US/Eastern'`, `'EST'`, `'UTC-5'`)
  - Coordenadas inválidas (latitude > 90, longitude < -180)
  - `Description` em texto livre com múltiplos idiomas
  - Severidade inconsistente (`1`, `'1'`, `'Low'`)
- **Tamanho:** ~1.5GB (amostra disponível)
- **Dificuldade:** 5/10

### 4. **Air Quality Data - India**
- **Kaggle ID:** `rohanrao/air-quality-data-in-india`
- **Problemas de limpeza:**
  - Dados de sensores com falhas (`-999`, `0`, valores absurdos)
  - Timestamps em múltiplos formatos
  - Estações com nomes variados (`'Delhi'`, `'New Delhi'`, `'Delhi CP'`)
  - Unidades inconsistentes (µg/m³, ppm, ppb misturados)
  - Missing data em padrões irregulares
- **Tamanho:** ~200MB
- **Dificuldade:** 5/10

### 5. **COVID-19 World Dataset**
- **Kaggle ID:** `imdevskp/corona-virus-report`
- **Problemas de limpeza:**
  - Formato muda diariamente
  - Nomes de países em inglês, espanhol, local
  - `Province/State` com múltiplos níveis (BR: `'SP'`, `'São Paulo'`, `'Sao Paulo'`)
  - Lat/Long como strings ou números
  - Dados retroativos que mudam
- **Tamanho:** ~50MB (mas cresce)
- **Dificuldade:** 6/10

### 6. **E-Commerce Sales Data (Brazil)**
- **Kaggle ID:** `olistbr/brazilian-ecommerce`
- **Problemas de limpeza:**
  - 9 tabelas relacionadas
  - CEPs brasileiros incompletos (`'01310'` vs `'01310-000'`)
  - Datas em formato BR (`'2017-10-02 10:56:33'` e `'02/10/2017'`)
  - Reviews em português com caracteres especiais
  - Valores monetários com e sem `R$`
  - Status de pedidos inconsistentes
- **Tamanho:** ~200MB
- **Dificuldade:** 6/10

### 7. **Customer Personality Analysis**
- **Kaggle ID:** `imakash3011/customer-personality-analysis`
- **Problemas de limpeza:**
  - Dados categóricos numéricos (`Education`: `1`, `2`, `3` sem dicionário)
  - Datas de nascimento como `'01-01-70'` (qual século?)
  - Renda como `'$50,000'`, `'50000'`, `'50K'`
  - `Dt_Customer` formatos misturados
  - Valores outlier extremos em `Income`, `MntSpent`
- **Tamanho:** ~2MB
- **Dificuldade:** 7/10

## 🔥 NÍVEL DESAFIADOR (8-14)

### 8. **IMDB Movies Dataset**
- **Kaggle ID:** `harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows`
- **Problemas de limpeza:**
  - `Runtime` como `'142 min'`, `'2 h 22 min'`, `'N/A'`
  - `Gross` como `'$187.7M'`, `'$123,456,789'`, `'Unknown'`
  - `Released_Year` com valores como `'2014-'`, `'TV Movie 2020'`
  - `Star` colunas com múltiplos atores separados por `,`
  - `Certificate` inconsistente (`'PG-13'`, `'PG13'`, `'Not Rated'`)
- **Tamanho:** ~500KB
- **Dificuldade:** 8/10

### 9. **Zillow Real Estate Data**
- **Kaggle ID:** `ahmedshahriarsakib/usa-real-estate-dataset`
- **Problemas de limpeza:**
  - Endereços em formato livre (`'123 Main St, Unit 4B, NY'`)
  - Preços como `'$1.2M'`, `'850,000'`, `'Call for price'`
  - `bed` e `bath` como `'3+'`, `'2-3'`, `'Studio'`
  - `acre_lot` com `'0.5 acres'`, `'10,000 sqft'`, `'N/A'`
  - Estados abreviados de formas diferentes
- **Tamanho:** ~100MB
- **Dificuldade:** 8/10

### 10. **World Bank Data - Indicators**
- **Kaggle ID:** `worldbank/world-development-indicators`
- **Problemas de limpeza:**
  - Dataset wide (60 anos × 200 países × 1500 indicadores)
  - Valores como `'..'` para missing, `'0'` para zero real
  - Nomes de indicadores extremamente longos
  - Códigos de país vs nomes vs regiões
  - Dados desbalanceados (alguns países com mais dados)
- **Tamanho:** ~500MB
- **Dificuldade:** 9/10

### 11. **Twitter US Airline Sentiment**
- **Kaggle ID:** `crowdflower/twitter-airline-sentiment`
- **Problemas de limpeza:**
  - Texto em inglês com gírias, abreviações, emojis
  - `@mentions` e `#hashtags` que precisam ser limpos
  - Datas de tweets em múltiplos timezones
  - `airline_sentiment` com `'negative'`, `'neutral'`, `'positive'` e `'0'`, `'1'`, `'2'`
  - `reason` coluna com múltiplas razões separadas por `;`
- **Tamanho:** ~5MB
- **Dificuldade:** 9/10

### 12. **Medical Appointment No-Shows (Brazil)**
- **Kaggle ID:** `joniarroba/noshowappointments`
- **Problemas de limpeza:**
  - Datas em formato BR (`'29-04-2016'`)
  - `PatientId` como float com .0
  - `Neighbourhood` com acentos e sem acentos
  - `Handcap` (typo no nome) com valores 0-4
  - `No-show` como `'Yes'`/`'No'` e `'0'`/`'1'`
  - `SMS_received` inconsistente
- **Tamanho:** ~100KB
- **Dificuldade:** 8/10

### 13. **Stack Overflow Developer Survey**
- **Kaggle ID:** `stackoverflow/stack-overflow-developer-survey-results`
- **Problemas de limpeza:**
  - 200+ colunas por ano, formato muda anualmente
  - Respostas em texto livre para perguntas abertas
  - `Salary` em múltiplas moedas e formatos
  - `Country` com nomes variados (`'USA'`, `'United States'`, `'US'`)
  - Checkbox responses como `'Python;JavaScript;SQL'`
  - Missing values diferentes (`NA`, `null`, ``, `'Prefer not to say'`)
- **Tamanho:** ~500MB (todos os anos)
- **Dificuldade:** 9/10

### 14. **Uber Pickups in New York City**
- **Kaggle ID:** `fivethirtyeight/uber-pickups-in-new-york-city`
- **Problemas de limpeza:**
  - Datetimes em Unix timestamp e formato humano
  - Lat/Long com precisão variada
  - Base location como `'B02512'` (códigos sem dicionário)
  - Valores duplicados/exatos (possível problema de coleta)
  - Timezone inconsistente (NYC mas sem DST handling)
- **Tamanho:** ~500MB
- **Dificuldade:** 8/10

## 💀 NÍVEL EXTREMO (15-20)

### 15. **Common Crawl Web Data Sample**
- **Kaggle ID:** `commoncrawl/cc-100-br`
- **Problemas de limpeza:**
  - HTML, JavaScript, CSS misturado com texto
  - Múltiplos encodings (UTF-8, ISO-8859-1, Windows-1252)
  - Texto em português com erros de OCR
  - URLs quebradas, parâmetros estranhos
  - Conteúdo duplicado/espelhado
- **Tamanho:** ~2GB (amostra)
- **Dificuldade:** 10/10

### 16. **Google Play Store Apps**
- **Kaggle ID:** `gauthamp10/google-playstore-apps`
- **Problemas de limpeza:**
  - `Size` como `'Varies with device'`, `'15M'`, `'2.3G'`
  - `Installs` como `'1,000+'`, `'10,000,000+'`, `'0'`
  - `Price` como `'$0.99'`, `'0'`, `'Everyone'` (erro)
  - `Last Updated` formatos variados
  - `Content Rating` com múltiplos sistemas
  - Reviews com texto em 50+ idiomas
- **Tamanho:** ~150MB
- **Dificuldade:** 9/10

### 17. **NASA - Meteorite Landings**
- **Kaggle ID:** `nasa/meteorite-landings`
- **Problemas de limpeza:**
  - Coordenadas inválidas (fora da Terra)
  - `year` como `'1899-01-01T00:00:00.000'` (data completa)
  - `mass` como `0.21` (gramas? kg?)
  - `recclass` com 400+ categorias não padronizadas
  - `fall` como `'Fell'`, `'Found'`, `'Unknown'`, `''`
  - Dados de 1700s com qualidade questionável
- **Tamanho:** ~2MB
- **Dificuldade:** 10/10

### 18. **Amazon Product Reviews**
- **Kaggle ID:** `datafiniti/amazon-product-reviews`
- **Problemas de limpeza:**
  - Reviews em múltiplos idiomas
  - `date` formatos: Unix, ISO, `'January 15, 2018'`
  - `rating` como `'5 out of 5 stars'`, `'5.0'`, `'5'`
  - Produtos duplicados com IDs diferentes
  - HTML entities nos textos (`&amp;`, `&quot;`)
  - Verified purchase vs não verificado misturado
- **Tamanho:** ~1GB
- **Dificuldade:** 10/10

### 19. **Financial News Headlines**
- **Kaggle ID:** `notlucasp/financial-news-headlines`
- **Problemas de limpeza:**
  - Headlines com encoding problems (`R$` como `R$`)
  - Datas em 5+ formatos diferentes
  - Fontes com nomes abreviados (`'WSJ'`, `'Reuters'`, `'FT'`)
  - Categorias inconsistentes (`'markets'`, `'Markets'`, `'stocks'`)
  - Headlines duplicadas com pequenas variações
  - Texto truncado com `[...]`
- **Tamanho:** ~50MB
- **Dificuldade:** 9/10

### 20. **Brazilian Census Data (IBGE)**
- **Kaggle ID:** `crisparada/brazilian-census`
- **Problemas de limpeza:**
  - Encoding Latin1 com acentos problemáticos
  - Códigos numéricos sem dicionário (precisa de lookup table)
  - `income` categorizado em faixas (`'A'`, `'B'`, `'C'`)
  - `education` com níveis brasileiros específicos
  - Dados de 2010 desatualizados mas complexos
  - `city` com e sem acentos, abreviaturas
- **Tamanho:** ~300MB
- **Dificuldade:** 10/10

---

## 🎯 COMO ESCOLHER:

### Para começar (recomendo):
1. **#1 Brazilian Houses to Rent** - Pequeno, brasileiro, problemas claros
2. **#2 Retail Sales Dataset** - Multi-tabelas, bom para JOINs
3. **#6 E-Commerce Sales Data** - Grande, real, ótimo para portfólio

### Para desafio sério:
1. **#8 IMDB Movies Dataset** - Texto livre, formatos variados
2. **#12 Medical Appointment No-Shows** - Brasileiro, problemas reais de saúde
3. **#16 Google Play Store Apps** - Dados do mundo real com todos os problemas

### Para mostrar expertise:
1. **#17 NASA Meteorite Landings** - Dados científicos complexos
2. **#18 Amazon Product Reviews** - Grande volume, texto natural
3. **#20 Brazilian Census Data** - Dados governamentais complexos

---

**Dica:** Comece com o **#1 Brazilian Houses to Rent** - é pequeno, brasileiro, e tem problemas reais mas gerenciáveis. Perfeito para seu primeiro desafio de limpeza! 🚀
