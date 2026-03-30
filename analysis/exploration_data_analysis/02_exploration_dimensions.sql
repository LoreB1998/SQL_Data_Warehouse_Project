/*
===============================================================================
ESPLORAZIONE DELLE DIMENSIONI

Obbiettivo: Identificare i valori unici (o categorie) per ogni dimensione.
Fine: Comprendere come i dati possono essere raggruppati o segmentati,
      il che è utile per le analisi successive.
===============================================================================
*/

-- Analizzare tutti i paesi da cui provengono i nostri clienti
SELECT DISTINCT country
FROM gold.dim_customers;

-- Analizzare tutte le macro-categorie, sotto-categorie e nome dei prodotti
SELECT DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY 1, 2, 3;

/*
===============================================================================
Esplorazione delle date
Obiettivo: Identificare le date di inizio e fine (confini).
           Comprendere l'ambito dei dati e l'arco temporale.
===============================================================================
*/

-- Date del primo e dell'ultimo ordine
SELECT
    -- 1. Date Estreme
    MIN(order_date)                                                         AS first_order_date,
    MAX(order_date)                                                         AS last_order_date,

    -- 2. Durata Formattata (Intervallo Postgres)
    AGE(MAX(order_date), MIN(order_date))                                   AS total_period,

    -- 3. Differenza Totale in ANNI
    EXTRACT(YEAR FROM MAX(order_date)) - EXTRACT(YEAR FROM MIN(order_date)) AS total_years_diff,
    -- 4. Differenza Totale in MESI
    ((EXTRACT(YEAR FROM MAX(order_date)) - EXTRACT(YEAR FROM MIN(order_date))) * 12)
        + (EXTRACT(MONTH FROM MAX(order_date)) - EXTRACT(MONTH FROM MIN(order_date)))
                                                                            AS total_months_diff,
    -- 5. Differenza Totale in GIORNI
    MAX(order_date) - MIN(order_date)                                       AS total_days_diff
FROM gold.fact_sales;


-- Cliente più giovane e cliente più anziano
SELECT
    -- Il più anziano
    MIN(birthdate) AS oldest_birthdate,
    EXTRACT(YEAR FROM AGE(NOW(), MIN(birthdate))) AS oldest_age,

    -- Il più giovane
    MAX(birthdate) AS youngest_birthdate,
    EXTRACT(YEAR FROM AGE(NOW(), MAX(birthdate))) AS youngest_age
FROM gold.dim_customers;