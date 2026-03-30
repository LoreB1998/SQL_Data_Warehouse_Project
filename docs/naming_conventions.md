# Naming Conventions

Insieme di regole e linee guida per la denominazione di qualsiasi elemento del progetto:
database, schema, tabelle, stored procedure, funzioni e colonne.

---

## Principi Generali

- **snake_case**: lettere minuscole e trattini bassi `_` per separare le parole.
- **Lingua**: inglese per tutti i nomi.
- **Termini riservati**: non utilizzare keyword riservate di SQL come nomi di oggetti.

---

## Naming delle Tabelle

### Layer Bronze

| Elemento                 | Regola                                                          |
|--------------------------|-----------------------------------------------------------------|
| **Formato**              | `<sistema_sorgente>_<entità>`                                   |
| **`<sistema_sorgente>`** | Nome del sistema di origine (es. `crm`, `erp`)                  |
| **`<entità>`**           | Nome esatto della tabella così come appare nel sistema sorgente |
| **Esempio**              | `crm_customer_info`                                             |

### Layer Silver

Stesse regole del layer Bronze.

| Elemento                 | Regola                                                          |
|--------------------------|-----------------------------------------------------------------|
| **Formato**              | `<sistema_sorgente>_<entità>`                                   |
| **`<sistema_sorgente>`** | Nome del sistema di origine (es. `crm`, `erp`)                  |
| **`<entità>`**           | Nome esatto della tabella così come appare nel sistema sorgente |
| **Esempio**              | `crm_customer_info`                                             |

### Layer Gold

I nomi devono essere significativi e allineati al business, con prefisso di categoria.

| Elemento          | Regola                                          |
|-------------------|-------------------------------------------------|
| **Formato**       | `<categoria>_<entità>`                          |
| **`<categoria>`** | Ruolo della tabella: `dim`, `fact`, `agg`       |
| **`<entità>`**    | Nome descrittivo allineato al dominio aziendale |
| **Esempi**        | `dim_customers`, `fact_sales`                   |

#### Glossario dei Prefissi

| Prefisso | Tipo             | Descrizione                                                                       | Esempi                          |
|----------|------------------|-----------------------------------------------------------------------------------|---------------------------------|
| `dim_`   | Dimension Table  | Dati descrittivi che contestualizzano i fatti (nomi, categorie, aree geografiche) | `dim_customers`, `dim_products` |
| `fact_`  | Fact Table       | Metriche quantitative di un processo di business (importi, quantità)              | `fact_sales`                    |
| `agg_`   | Aggregated Table | Dati pre-aggregati per velocizzare le query di reporting                          | `agg_sales_monthly`             |

---

## Naming delle Colonne

### Chiavi Surrogate

- **Formato**: `<nome_tabella>_key`
- Il suffisso `_key` indica una chiave surrogata generata internamente al DWH.
- **Esempio**: `customer_key` → chiave surrogata in `dim_customers`

### Colonne Tecniche

- **Formato**: `dwh_<nome_colonna>`
- Il prefisso `dwh_` è esclusivo per i metadati generati dal sistema.
- **Esempio**: `dwh_load_date` → data di caricamento del record nel DWH

---

## Stored Procedure

- **Formato**: `load_<layer>`
- Il campo `<layer>` rappresenta il livello target del caricamento.

| Stored Procedure | Layer target |
|------------------|--------------|
| `load_bronze`    | Bronze       |
| `load_silver`    | Silver       |
| `load_gold`      | Gold         |