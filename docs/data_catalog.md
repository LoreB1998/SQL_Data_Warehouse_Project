# 📖 Dizionario Dati: Layer Gold
## Panoramica
Il Layer Gold rappresenta il dato a livello di business, strutturato appositamente per supportare casi d'uso analitici e di reportistica. È composto da tabelle dimensionali (Dimension) e tabelle dei fatti (Fact), ottimizzate per misurare le metriche aziendali specifiche.

Il Layer Gold segue un'architettura a **Schema a Stella**, dove le tabelle dei fatti contengono i dati quantitativi e le tabelle dimensionali forniscono il contesto descrittivo.

---

## 🏛️ Dimension Tables (Tabelle Dimensionali)

### 1. `gold.dim_customers`

**Scopo:** Archivia i dettagli dei clienti arricchiti con dati demografici e geografici.

| Nome Colonna      | Tipo di Dato   | Descrizione                                                                                       |
|-------------------|----------------|---------------------------------------------------------------------------------------------------|
| `customer_key`    | `INT`          | Chiave surrogata che identifica univocamente ogni record cliente nella tabella dimensionale.      |
| `customer_id`     | `INT`          | Identificativo numerico univoco assegnato a ciascun cliente (Natural Key).                        |
| `customer_number` | `NVARCHAR(50)` | Identificativo alfanumerico del cliente, utilizzato per il tracciamento e il riferimento interno. |
| `first_name`      | `NVARCHAR(50)` | Il nome del cliente come registrato nel sistema sorgente.                                         |
| `last_name`       | `NVARCHAR(50)` | Il cognome del cliente come registrato nel sistema sorgente.                                      |
| `gender`          | `NVARCHAR(20)` | Il genere del cliente (integrato da CRM ed ERP).                                                  |
| `country`         | `NVARCHAR(50)` | Il paese di residenza del cliente.                                                                |
| `marital_status`  | `NVARCHAR(20)` | Lo stato civile del cliente.                                                                      |
| `birthdate`       | `DATE`         | La data di nascita del cliente.                                                                   |
| `create_date`     | `DATE`         | La data in cui il record del cliente è stato creato nel sistema.                                  |

### 2. `gold.dim_products`

**Scopo:** Contiene l'anagrafica dei prodotti con le relative gerarchie di categoria e dettagli tecnici.

| Nome Colonna     | Tipo di Dato    | Descrizione                                                                            |
|------------------|-----------------|----------------------------------------------------------------------------------------|
| `product_key`    | `INT`           | Chiave surrogata che identifica univocamente ogni prodotto nella tabella dimensionale. |
| `product_id`     | `INT`           | Identificativo numerico univoco del prodotto dal sistema sorgente.                     |
| `product_number` | `NVARCHAR(50)`  | Codice identificativo di business del prodotto (es. SKU).                              |
| `product_name`   | `NVARCHAR(100)` | Nome completo del prodotto.                                                            |
| `category_id`    | `NVARCHAR(50)`  | Identificativo della categoria di appartenenza.                                        |
| `category`       | `NVARCHAR(50)`  | Nome della categoria principale (es. Componenti, Bici).                                |
| `subcategory`    | `NVARCHAR(50)`  | Nome della sottocategoria specifica.                                                   |
| `maintenance`    | `NVARCHAR(20)`  | Indica se il prodotto richiede manutenzione o meno.                                    |
| `cost`           | `NUMERIC`       | Costo unitario del prodotto.                                                           |
| `product_line`   | `NVARCHAR(20)`  | Linea di appartenenza del prodotto.                                                    |
| `start_date`     | `DATE`          | Data di inizio validità del prodotto nel catalogo.                                     |

---
## 🔢 Tabelle dei Fatti (Fact Tables)

### 3. `gold.fact_sales`

**Scopo:** Memorizza le transazioni di vendita e le metriche chiave per l'analisi delle performance.

| Nome Colonna    | Tipo di Dato   | Descrizione                                                              |
|-----------------|----------------|--------------------------------------------------------------------------|
| `order_number`  | `NVARCHAR(50)` | Identificativo univoco della transazione o dell'ordine di vendita.       |
| `product_key`   | `INT`          | Chiave esterna che collega la vendita alla tabella `gold.dim_products`.  |
| `customer_key`  | `INT`          | Chiave esterna che collega la vendita alla tabella `gold.dim_customers`. |
| `order_date`    | `DATE`         | Data in cui è stato effettuato l'ordine.                                 |
| `shipping_date` | `DATE`         | Data in cui la merce è stata spedita.                                    |
| `due_date`      | `DATE`         | Data di scadenza prevista per il pagamento.                              |
| `sales_amount`  | `NUMERIC`      | Importo totale della vendita (Fatturato).                                |
| `quantity`      | `INT`          | Numero di unità vendute.                                                 |
| `unit_price`    | `NUMERIC`      | Prezzo unitario applicato al momento dell'ordine.                        |
