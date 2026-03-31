/*
===============================================================================
Analisi della Segmentazione dei Dati (Data Segmentation)
Obiettivo: Raggruppare i dati in fasce o "bin" basati su intervalli specifici.
Perché: Permette di identificare pattern e correlazioni tra diverse misure
       (es. Volume delle vendite vs frequenza degli ordini).
Esempio: "Quanti clienti spendono tra 0-100€ rispetto a quelli che spendono > 1000€?"
         "Qual è la fascia di prezzo più popolare tra i nostri prodotti?"
===============================================================================
*/

-- Segmentazione dei prodotti in fasce di prezzo e conta quanti prodotti rientrano in ciascuna fascia
WITH product_segments AS (SELECT product_key,
                                 product_name,
                                 cost,
                                 CASE
                                     WHEN cost < 100 THEN '1. Below 100'
                                     WHEN cost < 500 THEN '2. 100-500' -- Qui arrivano solo i valori >= 100
                                     WHEN cost < 1000 THEN '3. 500-1000' -- Qui arrivano solo i valori >= 500
                                     ELSE '4. Over 1000' -- Qui tutto ciò che è >= 1000
                                     END AS cost_range
                          FROM gold.dim_products)
SELECT cost_range,
       COUNT(product_key) AS total_product
FROM product_segments
GROUP BY cost_range
ORDER BY total_product DESC;

/*
===============================================================================
Analisi della Segmentazione Clienti (Customer Segmentation)
Obiettivo: Classificare i clienti in VIP, Regular e New.
Logica:
  - VIP: Storia >= 12 mesi E spesa > 5000€
  - Regular: Storia >= 12 mesi E spesa <= 5000€
  - New: Storia < 12 mesi
===============================================================================
*/


-- 1. Prima CTE: Calcolo delle metriche base per ogni cliente
WITH customer_metrics AS (
    SELECT
        customer_key,
        SUM(sales_amount) AS total_spent,
        (EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
         EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date)))) + 1 AS lifespan_months
    FROM gold.fact_sales
    GROUP BY customer_key
),

-- 2. Seconda CTE: Assegnazione dei segmenti basata sulle metriche
customer_segmentation AS (
    SELECT
        customer_key,
        CASE
            WHEN lifespan_months >= 12 AND total_spent > 5000 THEN '1. VIP'
            WHEN lifespan_months >= 12 AND total_spent <= 5000 THEN '2. Regular'
            ELSE '3. New'
        END AS customer_segment
    FROM customer_metrics
)

-- 3. Risultato Finale: Aggregazione per segmento
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers,
    -- Opzionale: calcolo della percentuale sul totale
    ROUND(COUNT(customer_key) * 100.0 / SUM(COUNT(customer_key)) OVER (), 2) || '%' AS pct_of_total
FROM customer_segmentation
GROUP BY customer_segment
ORDER BY customer_segment DESC;

