# Cloud Data Engineering — End-to-End ETL Pipeline (Python, Airflow, dbt & PostgreSQL)

Este projeto demonstra a construção de um **pipeline de dados completo em ambiente cloud**, cobrindo **ingestão, orquestração, transformação, modelagem e qualidade de dados**, utilizando ferramentas amplamente adotadas em ambientes produtivos de **Data Engineering**.

O pipeline foi desenhado para simular um cenário real de engenharia de dados, indo além de data warehouses gerenciados, com foco em **infraestrutura, automação, versionamento e observabilidade**.

---

## 🎯 Objetivo do Projeto

- Construir um pipeline **end-to-end** desde a extração de dados brutos até camadas analíticas.
- Trabalhar com **dados externos via API**, lidando com falhas, schemas instáveis e dados incompletos.
- Implementar **orquestração automatizada** com controle de dependências, retries e execução incremental.
- Aplicar **boas práticas modernas de transformação de dados** com dbt.
- Utilizar **arquitetura em camadas (Medallion Architecture)** fora de um data warehouse gerenciado.
- Simular um ambiente próximo ao **mundo real de Data Engineering em cloud**.

---

## 🧱 Stack Tecnológica

### ☁️ Infraestrutura & Cloud
- **Cloud Provider:** DigitalOcean  
- **Ambiente:** Linux VM (Droplet)
- **Containerização:** Docker & Docker Compose

**Por quê?**  
Permite aprender conceitos reais de infraestrutura, rede, processos e deploy, que são abstraídos em soluções totalmente gerenciadas.

---

### 🗄️ Banco de Dados
- **PostgreSQL**

Utilizado como:
- Camada **Raw (Bronze)** para dados brutos ingeridos
- Base para transformação e modelagem analítica

---

### 🔌 Ingestão de Dados
- **Python**
  - `requests` / `aiohttp`
  - `pandas` (uso leve)
- **Fonte:** API pública (dados reais e não tratados)

**Responsabilidade:**
- Extração dos dados
- Normalização mínima de schema
- Persistência dos dados brutos sem regras de negócio

---

### 🔄 Orquestração
- **Apache Airflow**

**Responsabilidade:**
- Orquestrar todo o pipeline de ponta a ponta
- Controlar dependências entre etapas
- Implementar:
  - retries
  - scheduling
  - backfill
  - logs e monitoramento

---

### 🧪 Transformação & Modelagem
- **dbt Core**

**Responsabilidade:**
- Transformação dos dados usando SQL versionado
- Implementação da **Medallion Architecture**
- Aplicação de regras de negócio
- Garantia de qualidade via testes automatizados

Camadas:
- **Bronze:** dados brutos espelhados
- **Silver:** dados limpos, padronizados e deduplicados
- **Gold:** dados modelados para analytics e BI

---

### 📈 Consumo Analítico
- Camada **Gold** pronta para:
  - BI (Power BI / Tableau)
  - Análises exploratórias
  - Relatórios executivos

---

### ⚙️ Dev Experience & Qualidade
- **GitHub**
- **GitHub Actions (CI)**
- **GitHub Copilot**
- **JetBrains DataGrip / PyCharm**

**Responsabilidade:**
- Versionamento de código
- Automação de validações (lint, dbt tests)
- Padronização do ambiente de desenvolvimento

---

## 🔄 Arquitetura do Pipeline


