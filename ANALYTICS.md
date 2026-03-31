# 📊 Analytics & Data Analysis Suite

Catalogo delle query analitiche implementate nel Data Warehouse, organizzate in due categorie: **Exploration Data Analysis** (Data Quality & Structure Validation) e **Advanced Queries** (Strategic Analytics Patterns).

---

## 📑 Indice

1. [Exploration Data Analysis](#exploration-data-analysis)
2. [Advanced Queries](#advanced-queries)
3. [Come Eseguire le Analisi](#come-eseguire-le-analisi)
4. [Prerequisiti](#prerequisiti)

---

## <a id="exploration-data-analysis"></a>🔍 Exploration Data Analysis

Suite di query per **validare la struttura e la qualità dei dati** nel Data Warehouse, inclusi controlli su metadati, distribuzioni, cardinalità e anomalie.

| # | File | Scopo | Tipo di Insight |
|---|------|-------|-----------------|
| 1 | [`01_exploration_meta.sql`](analysis/exploration_data_analysis/01_exploration_meta.sql) | Elencare tutti gli oggetti (Tabelle, View, Schema) del DWH | Metadati strutturali |
| 2 | [`02_exploration_dimensions.sql`](analysis/exploration_data_analysis/02_exploration_dimensions.sql) | Analizzare il contenuto e la distribuzione delle Dimension Tables | Qualità dimensioni |
| 3 | [`03_exploration_measures.sql`](analysis/exploration_data_analysis/03_exploration_measures.sql) | Verificare le metriche quantitative e loro distribuzione | Qualità metriche |
| 4 | [`04_exploration_magnitude_analysis.sql`](analysis/exploration_data_analysis/04_exploration_magnitude_analysis.sql) | Analizzare la scala dei dati (min, max, media, distribuzione) | Cardinalità e ranges |
| 5 | [`05_exploration_ranking_analysis.sql`](analysis/exploration_data_analysis/05_exploration_ranking_analysis.sql) | Identificare i Top N elementi per ogni dimensione | Ranking e concentrazione |

### 💡 Utilizzo

- **Data Quality Validation**: Verificare integrità e distribuzione post-load
- **Structural Analysis**: Mappare schemi, dimensioni, metriche disponibili
- **Anomaly Detection**: Identificare valori outlier, missing data, distribuzione anomale
- **Performance Monitoring**: Monitorare cardinalità, ranges, concentrazione dati

### 🔗 Sequenza di Esecuzione

Esecuzione consigliata per una validazione completa:

```
01_exploration_meta.sql
    ↓
02_exploration_dimensions.sql → 03_exploration_measures.sql
    ↓
04_exploration_magnitude_analysis.sql
    ↓
05_exploration_ranking_analysis.sql
```

---

## <a id="advanced-queries"></a>🚀 Advanced Queries

Suite di query per **analytics strategica e business intelligence**, implementando pattern analitici avanzati per supportare decision-making data-driven.

| # | File | Pattern Analitico | Caso d'Uso |
|---|------|-------------------|-----------|
| 1 | [`01_change_over_time.sql`](analysis/advanced_queries/01_change_over_time.sql) | Time Series & Trends | Analizzare l'evoluzione temporale delle vendite (crescita, stagionalità) |
| 2 | [`02_cumulative_analysis.sql`](analysis/advanced_queries/02_cumulative_analysis.sql) | Running Totals / YTD | Calcolare cumulative totals e Year-To-Date metrics |
| 3 | [`03_performance_analysis.sql`](analysis/advanced_queries/03_performance_analysis.sql) | Comparative Performance | Confrontare performance tra periodi, prodotti, clienti |
| 4 | [`04_part_to_whole.sql`](analysis/advanced_queries/04_part_to_whole.sql) | Mix Analysis / Contribution | Analizzare la composizione (% contribution, mix prodotti) |
| 5 | [`05_data_segmentation.sql`](analysis/advanced_queries/05_data_segmentation.sql) | Cohort & Segmentation | Segmentare clienti/prodotti per profittabilità, comportamento |
| 6 | [`06_reporting.sql`](analysis/advanced_queries/06_reporting.sql) | Executive Dashboard Metrics | Metriche aggregate per reporting e BI |

### 🎯 Applicazioni

- **Strategic Analytics**: Time series analysis, trend identification, forecasting support
- **Executive Reporting**: KPI aggregation, dashboard metrics, performance benchmarking
- **Operational Intelligence**: Segmentation, cohort analysis, comparative performance
- **Business Intelligence**: Mix analysis, contribution modeling, opportunity identification

### 🛠️ Technical Patterns Implemented

- **Time Series Analysis**: Temporal aggregations, trend analysis, YoY comparisons
- **Cumulative Calculations**: Running totals, YTD metrics, progressive analysis
- **Comparative Performance**: Benchmarking, period-over-period analysis, variance analysis
- **Mix & Composition**: Contribution analysis, segment breakdown, mix modeling
- **Segmentation & Cohort Analysis**: Classification, behavioral segmentation, RFM analysis
- **Executive Metrics**: Aggregated KPIs, SLA monitoring, scorecard metrics

---


## <a id="come-eseguire-le-analisi"></a>🔗 Come Eseguire le Analisi

### <a id="prerequisiti"></a>Prerequisiti

✅ Database PostgreSQL con dati caricati nel Layer Gold (`dim_*` e `fact_*` tables)  
✅ Client SQL: DataGrip, pgAdmin, psql, o DBeaver  
✅ Autorizzazioni di lettura sugli schemi `gold`, `silver`, `bronze`  

### Passaggi

1. **Copia il codice SQL** dalla query di interesse
2. **Incolla nel tuo client SQL** (DataGrip, pgAdmin, psql)
3. **Esegui la query** (Ctrl+Enter su DataGrip / Cmd+Enter su Mac)
4. **Analizza i risultati** nel tab Results

### Esempio con psql (linea di comando)

```bash
# Connettiti al database
psql -U username -d database_name -h localhost

# Esegui una query (il file viene riportato qui)
\i analysis/exploration_data_analysis/01_exploration_meta.sql

# Vedi i risultati
# ...
```

---

## 📊 Execution Workflow

### **Recommended Analysis Progression**

```
Phase 1: Data Validation
├── 01_exploration_meta.sql
├── 02_exploration_dimensions.sql
└── 03_exploration_measures.sql

Phase 2: Data Profiling
├── 04_exploration_magnitude_analysis.sql
└── 05_exploration_ranking_analysis.sql

Phase 3: Strategic Analytics
├── 01_change_over_time.sql
├── 04_part_to_whole.sql
└── 06_reporting.sql
```

---

## 🎓 Casi d'Uso di Business

### Domanda: "Come stanno andando le vendite?"
→ Usa: `01_change_over_time.sql` + `06_reporting.sql`

### Domanda: "Quali prodotti guidano la crescita?"
→ Usa: `04_part_to_whole.sql` + `01_change_over_time.sql`

### Domanda: "Quali clienti sono i più profittevoli?"
→ Usa: `05_data_segmentation.sql` + `03_performance_analysis.sql`

### Domanda: "Come è progredito il business da inizio anno?"
→ Usa: `02_cumulative_analysis.sql`

---

## ⚙️ Implementation Notes

- **Query Composition**: Modify and combine queries for specific use cases and business context
- **Performance Optimization**: Use LIMIT clauses for initial testing on large datasets; consider materialized views for recurring queries
- **Data Freshness**: Integrate queries into scheduled ETL pipelines for continuous analytics
- **Reporting Integration**: Export results to BI tools (Tableau, Power BI) or reporting platforms
- **Version Control**: Maintain query variants in separate files for A/B analysis or historical comparisons

---

*Ultimo aggiornamento: Marzo 2026*
