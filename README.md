# SQL Data Warehouse & Analytics Project: Medallion Architecture con PostgreSQL
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Data Engineering](https://img.shields.io/badge/Data_Engineering-FFD700?style=for-the-badge&logo=databricks&logoColor=black)
![Medallion Architecture](https://img.shields.io/badge/Medallion_Architecture-Gold_Silver_Bronze-orange?style=for-the-badge)
![Analytics](https://img.shields.io/badge/Analytics-11_Queries-0078D4?style=for-the-badge)

Questo progetto presenta una soluzione **end-to-end** di Data Warehousing e Analytics, implementando un'architettura **Medallion** per trasformare dati grezzi di vendita (ERP + CRM) in insight strategici. Include:
- ✅ Data Warehouse moderno a 3 layer (Bronze → Silver → Gold)
- ✅ Star Schema ottimizzato per reporting e BI
- ✅ 11 query analitiche (5 exploration + 6 advanced patterns)

Sviluppato seguendo le best practice del settore per data engineering, modellazione dati, e analytics.

---

## 📑 Indice dei Contenuti

- [Obiettivi](#-obiettivi-del-progetto)
- [Architettura Medallion](#-architettura-del-progetto-medallion)
- [Analytics & Analisi](#-analytics--data-analysis)
- [Tech Stack](#-tech-stack)
- [Quick Start](#-quick-start--come-iniziare)
- [Project Structure](#-project-structure)
- [Naming Conventions](#-regole-di-nomenclatura--best-practices)
- [Documentazione](#-documentazione)
- [Roadmap](#-roadmap-di-sviluppo)

## 🎯 Obiettivi del Progetto

Sviluppare un Data Warehouse moderno utilizzando **PostgreSQL** per consolidare i dati di vendita, permettendo una reportistica avanzata e decisioni basate sui dati.

### Ingegneria dei Dati (Data Engineering)
- **Sorgenti Dati**: Integrazione di dati da due sistemi distinti (**ERP** e **CRM**) forniti in formato CSV.
- **Qualità del Dato**: Pulizia e standardizzazione dei dati (Data Cleansing) per risolvere anomalie prima dell'analisi.
- **Integrazione**: Unione delle sorgenti in un unico modello dati (Star Schema) ottimizzato per le query analitiche.
- **Documentation**: Creazione di un **Data Catalog** e diagrammi di flusso per supportare stakeholder e team analytics.

### Analytics & BI
Fornire insight dettagliati su:
- **Comportamento dei Clienti** (Customer Behavior)
- **Performance dei Prodotti** (Product Performance)
- **Trend delle Vendite** (Sales Trends)

---

## 📊 Analytics & Data Analysis

Oltre al Data Warehouse, il progetto include **11 query analitiche** organizzate in due categorie:

### 🔍 Exploration Data Analysis (5 query)
Query introduttive per **scoprire e validare i dati**:
- Metadati strutturali e oggetti del DWH
- Distribuzione e qualità delle dimensioni
- Metriche quantitative e loro distribuzione
- Cardinalità e scale dei dati
- Ranking e concentrazione

👉 **Ideale per**: Onboarding, validazione post-load, audit di qualità

### 🚀 Advanced Queries (6 query)
Pattern analitici complessi per **rispondere a domande strategiche**:
- Time Series & Trends (evoluzione temporale)
- Cumulative Analysis (Running totals, YTD metrics)
- Performance Comparative (benchmarking tra periodi)
- Part-to-Whole Analysis (contribuzione, mix prodotti)
- Data Segmentation (cohort, customer profiling)
- Executive Dashboard Metrics (KPI aggregati)

👉 **Ideale per**: Reportistica, Strategic insights, Decision support

📖 **Per i dettagli su tutte le analisi**, vedi [**ANALYTICS.md**](ANALYTICS.md)

---

## 🏗️ Architettura del Progetto (Medallion)

Il progetto è suddiviso in tre layer logici per garantire tracciabilità e qualità:

![Architecture Overview](assets/architecture.svg)

1.  **🥉 Bronze Layer**: Dati grezzi importati "as-is" dai sistemi sorgente (ERP/CRM). Obiettivo: Tracciabilità e Debugging.
2.  **🥈 Silver Layer**: Dati puliti, standardizzati e normalizzati. In questa fase vengono gestite le colonne derivate e l'arricchimento dei dati.
3.  **🥇 Gold Layer**: Dati "Business-Ready" pronti per il consumo. Utilizzo di **Star Schema** (Fact e Dimension tables) e viste aggregate.

### Dettaglio dei Layer

![Data Layers - Part 1](assets/data_layers_1.svg)

![Data Layers - Part 2](assets/data_layers_2.svg)

---

## 🔗 Integrazione delle Sorgenti Dati

![Data Integration Model](assets/data_integration_model.svg)

---

## ⭐ Star Schema (Gold Layer)

![Star Schema](assets/star_schema.svg)

---

## 🛠️ Tech Stack
- **Database**: PostgreSQL (gestito tramite DataGrip)
- **Linguaggio**: SQL (PL/pgSQL per le Stored Procedure)
- **Documentazione**: Draw.io (Diagrammi di Flusso e ERD)
- **Version Control**: Git / GitHub

---

## 📏 Regole di Nomenclatura & Best Practices

Per garantire la manutenibilità, il progetto segue regole rigorose:
- **Layer Bronze/Silver**: Le tabelle mantengono il nome originale preceduto dal sistema sorgente (es. `crm_customer_info`).
- **Layer Gold**: Utilizzo di nomi parlanti con prefissi `dim_` (Dimensioni), `fact_` (Fatti) e `agg_` (Aggregati).
- **Chiavi Surrogate**: Tutte le tabelle dimensionali utilizzano chiavi primarie con suffisso `_key` (es. `customer_key`).
- **Colonne Tecniche**: Ogni record include metadati di sistema con prefisso `dwh_` (es. `dwh_load_date`) per il monitoraggio del carico.

---

## 🚀 Workflow di Sviluppo

Il ciclo di vita di ogni layer segue questo flusso:

![Data Flow](assets/data_flow.svg)

1.  **Analysis**: Analisi dei sistemi sorgente e degli oggetti di business.
2.  **Coding**: Sviluppo delle procedure di carico (`load_bronze`, `load_silver`, `load_gold`).
3.  **Validation**: Check di completezza, schema e correttezza dei dati.
4.  **Versioning**: Documentazione e commit del codice su repository Git.

---

## ⚙️ Quick Start – Come Iniziare

### Prerequisiti
- ✅ PostgreSQL 12+ installato e in esecuzione
- ✅ Client SQL: DataGrip, pgAdmin, psql, o DBeaver
- ✅ 50 MB di spazio disco per i dati di esempio

### Opzione 1️⃣: Build Completo (DW + Analisi)
**Tempo stimato**: 10-15 minuti  
**Per chi vuole**: Esperienza end-to-end

```bash
# 1. Crea il database
psql -U postgres -f scripts/setup/01_creation_database_and_schemas.sql

# 2. Carica il Bronze Layer
psql -U postgres -d warehouse -f scripts/bronze/02_ddl_bronze.sql
psql -U postgres -d warehouse -f scripts/bronze/03_proc_load_bronze.sql

# 3. Carica il Silver Layer
psql -U postgres -d warehouse -f scripts/silver/04_ddl_silver.sql
psql -U postgres -d warehouse -f scripts/silver/05_check_bronze_before_silver_load.sql
psql -U postgres -d warehouse -f scripts/silver/06_proc_load_silver.sql

# 4. Carica il Gold Layer
psql -U postgres -d warehouse -f scripts/gold/08_ddl_gold.sql

# 5. Esplora le analisi
psql -U postgres -d warehouse -f analysis/exploration_data_analysis/01_exploration_meta.sql
```

### Opzione 2️⃣: Solo Data Warehouse
**Tempo stimato**: 5-10 minuti  
**Per chi vuole**: Solo architettura DW

Esegui solo i passaggi 1-4 dell'Opzione 1

### Opzione 3️⃣: Solo Analisi (su DWH esistente)
**Tempo stimato**: 1-2 minuti  
**Per chi vuole**: Esplorare le 11 query analitiche

Esegui i file da `analysis/exploration_data_analysis/*.sql` e `analysis/advanced_queries/*.sql`

📖 **Per dettagli completi ed esempi**, vedi [**ANALYTICS.md**](ANALYTICS.md)

---

## 📂 Project Structure

```
📁 SQL_Data_Warehouse_Project/
├── 📄 README.md                          ← Questo file
├── 📄 ANALYTICS.md                       ← Guida completa alle 11 query analitiche
├── 📄 LICENSE
├── 📄 docs/
│   ├── data_catalog.md                   ← Dizionario dati (Gold Layer)
│   └── naming_conventions.md             ← Regole di nomenclatura
├── 📁 scripts/                           ← SQL per costruire il DW
│   ├── setup/01_creation_database_and_schemas.sql
│   ├── bronze/                           ← Raw data as-is
│   │   ├── 02_ddl_bronze.sql
│   │   └── 03_proc_load_bronze.sql
│   ├── silver/                           ← Cleaned & standardized data
│   │   ├── 04_ddl_silver.sql
│   │   ├── 05_check_bronze_before_silver_load.sql
│   │   └── 06_proc_load_silver.sql
│   └── gold/                             ← Business-ready analytics data
│       ├── 07_gold_transformation_testing.sql
│       └── 08_ddl_gold.sql
├── 📁 analysis/                          ← 11 query analitiche
│   ├── exploration_data_analysis/        ← Discovery & validation (5 query)
│   │   ├── 01_exploration_meta.sql
│   │   ├── 02_exploration_dimensions.sql
│   │   ├── 03_exploration_measures.sql
│   │   ├── 04_exploration_magnitude_analysis.sql
│   │   └── 05_exploration_ranking_analysis.sql
│   └── advanced_queries/                 ← Strategic analysis (6 query)
│       ├── 01_change_over_time.sql
│       ├── 02_cumulative_analysis.sql
│       ├── 03_performance_analysis.sql
│       ├── 04_part_to_whole.sql
│       ├── 05_data_segmentation.sql
│       └── 06_reporting.sql
├── 📁 datasets/                          ← Sample data (ERP + CRM)
│   ├── source_crm/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   └── source_erp/
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
├── 📁 assets/                            ← Diagrammi (Draw.io)
│   ├── architecture.drawio
│   ├── data_layers_1.svg
│   ├── data_layers_2.svg
│   ├── data_integration_model.svg
│   ├── data_flow.svg
│   └── star_schema.svg
└── 📄 README.md
```

### 🗂️ Descrizione Cartelle

| Cartella | Contenuto | Quando usare |
|----------|-----------|----------|
| **scripts/setup** | Creazione database e schema | 1º step, una volta |
| **scripts/bronze** | DDL e Stored Procedure per Raw Data | 2º step |
| **scripts/silver** | Trasformazioni e Data Cleansing | 3º step |
| **scripts/gold** | Star Schema e viste per BI/Analytics | 4º step |
| **analysis/exploration_data_analysis** | 5 query per scoprire i dati | Dopo caricamento, per validare |
| **analysis/advanced_queries** | 6 query pattern analitici | Per reporting e strategic insights |
| **docs** | Data Catalog e Naming Conventions | Sempre, come riferimento |
| **datasets** | Sample CSV da ERP e CRM | Per load iniziale |
| **assets** | Diagrammi di architettura | Per capire il design |

---

---

## 📍 Roadmap di Sviluppo

Questo progetto è stato sviluppato in 4 fasi principali:

1. **Phase 1: Data Engineering Fundamentals** (Bronze + Silver)
   - Ingestion da CSV (ERP + CRM)
   - Data Cleansing e standardizzazione
   - Validation checks

2. **Phase 2: Dimensional Modeling** (Gold Layer)
   - Star Schema design
   - Fact e Dimension tables
   - Business-ready metrics

3. **Phase 3: Exploratory Analysis** (Exploration Data Analysis)
   - Metadati e struttura
   - Data quality checks
   - Discovery queries

4. **Phase 4: Strategic Analytics** (Advanced Queries)
   - Time series e trends
   - Performance analysis
   - Customer segmentation
   - Executive reporting

### 🎯 Possibili Estensioni Future

- Incrementale load (CDC - Change Data Capture)
- Dati in tempo reale (Streaming)
- Predictive analytics e ML
- Dashboard interattivo (Tableau, Power BI, Looker)
- Data quality monitoring (Great Expectations, dbt tests)
- Multi-tenancy support

---

## 📚 Documentazione Completa

| Documento | Scopo |
|-----------|-------|
| 📖 [**ANALYTICS.md**](ANALYTICS.md) | Guida completa alle 11 query analitiche |
| 📖 [**Data Catalog**](docs/data_catalog.md) | Dizionario dati e metriche del Gold Layer |
| 📖 [**Naming Conventions**](docs/naming_conventions.md) | Regole di nomenclatura per DB, tabelle, colonne |
| 🎨 [**assets/architecture.drawio**](assets/architecture.drawio) | Diagramma architettuale (modificabile) |

---

## ✨ Highlights del Progetto

✅ **Architettura Medallion completa** – 3 layer con tracciabilità e audit trail  
✅ **11 query analitiche** – Exploration + Advanced patterns  
✅ **Star Schema ottimizzato** – Pronto per BI e reporting  
✅ **Best practices** – Naming conventions, documentation, version control  
✅ **Portfolio-ready** – Codice pulito e professionale  
✅ **Fully documented** – Data Catalog, flowchart, guide passo-passo  

---

## 💼 Competenze Dimostrate

- **Data Warehouse Architecture** – Medallion pattern a 3 layer, tracciabilità end-to-end, audit trail completo
- **Dimensional Modeling** – Star Schema design, Fact & Dimension tables, schema optimization
- **SQL Avanzato** – Window functions, CTEs, stored procedures, aggregazioni complesse, performance tuning
- **ETL/ELT Orchestration** – Data ingestion da CSV, cleansing, transformation pipeline, validation framework
- **Data Quality & Governance** – Data profiling, quality validation, lineage tracking, documentation rigorous
- **Analytics & Reporting** – Time series analysis, performance benchmarking, customer segmentation, KPI metrics
- **Software Engineering** – Version control, code organization, comprehensive documentation, naming conventions
- **Database Design** – Schema optimization, constraint design, indexing strategy, query optimization

---

*Progetto realizzato da Lorenzo Barbato  –  Marzo 2026*
