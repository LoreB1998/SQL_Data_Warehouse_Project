/*
===============================================================================
Analisi delle Performance (Performance Analysis)
Obiettivo: Confrontare il valore attuale (es. Sales) con un valore target (Goal).
Perché: Permette di misurare il successo aziendale, identificare i reparti
       sotto-performanti e monitorare il raggiungimento dei KPI.
Esempio: "Abbiamo raggiunto l'obiettivo di vendita di 1M€ questo mese?" o
         "Qual è la distanza percentuale dal nostro target annuale?"
===============================================================================
*/

-- Analisi della Performance Annuale dei Prodotti attraverso il confronto tra le vendite
-- di ogni singolo prodotto, la sua performance media storica e i risultati dell'anno precedente.

WITH yearly_product_sales AS (SELECT EXTRACT(YEAR FROM fs.order_date) AS order_year,
                                     dp.product_name                  AS product_name,
                                     SUM(fs.sales_amount)             AS current_sales
                              FROM gold.fact_sales fs
                                       LEFT JOIN gold.dim_products dp on fs.product_key = dp.product_key
                              WHERE order_date IS NOT NULL
                              GROUP BY 1, 2)
SELECT order_year,
       product_name,
       current_sales,
       AVG(current_sales) OVER (PARTITION BY product_name)                                     AS avg_sales,
       current_sales - AVG(current_sales) OVER (PARTITION BY product_name)                     AS diff_avg,
       CASE
           WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN '🟢 Above Avg'
           WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN '🔴 Under Avg'
           ELSE '🟠 Avg'
           END                                                                                 AS avg_change,
    -- Year-over-Year (YoY) Analysis
       LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)                 AS py_sales,
       current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
       CASE
           WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN '🟢 Increase'
           WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN '🔴 Decrease'
           ELSE '🟠 No Change'
           END
FROM yearly_product_sales
ORDER BY product_name, order_year;