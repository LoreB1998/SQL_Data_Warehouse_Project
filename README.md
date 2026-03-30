# SQL Data Warehouse Project: Medallion Architecture con PostgreSQL

Questo progetto presenta una soluzione completa di Data Warehousing e Analytics, focalizzata sull'implementazione di un'architettura **Medallion** per trasformare dati grezzi in insight strategici. Il progetto è stato sviluppato seguendo le best practice del settore per l'ingegneria dei dati e la modellazione analitica.

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

## ⚙️ Come eseguire il progetto (How to Run)
Per riprodurre questo Data Warehouse sul tuo ambiente locale:
1. Assicurati di avere **PostgreSQL** installato e in esecuzione.
2. Clona questo repository.
3. Esegui gli script SQL seguendo l'ordine numerico progressivo indicato nei nomi dei file (es. `01_...`, `02_...`, ecc.) tramite DataGrip o psql.

---

## 📚 Documentazione Aggiuntiva
Per i dettagli sulle logiche di business e le metriche, consulta il dizionario dati:
* 📖 [**Data Catalog (Layer Gold)**](docs/data_catalog.md)

---
*Progetto realizzato da Lorenzo Barbato.*
