/*
===============================================================================
REPORT CLIENTI (Customer Report)
===============================================================================
Scopo:
    - Questo report consolida le metriche chiave e i comportamenti dei clienti.

Punti salienti:
    1. Raccoglie campi essenziali come nomi, età e dettagli delle transazioni.
    2. Aggrega metriche a livello di cliente:
        - ordini totali
        - vendite totali
        - quantità totale acquistata
        - prodotti totali (unici)
        - lifespan (longevità in mesi)
    3. Segmentazione dei clienti in categorie (VIP, Regular, New) e fasce d'età.
    4. Calcola KPI di valore:
        - recency (mesi dall'ultimo ordine)
        - valore medio dell'ordine (AOV)
        - spesa media mensile
===============================================================================
*/
CREATE VIEW gold.report_customers AS
WITH base_query AS (
    SELECT fs.order_number,
           fs.product_key,
           fs.order_date,
           fs.sales_amount,
           fs.quantity,
           dc.customer_key,
           dc.customer_number,
           CONCAT(dc.first_name, ' ', dc.last_name)           AS customer_name,
           EXTRACT(YEAR FROM AGE(CURRENT_DATE, dc.birthdate)) AS age
    FROM gold.fact_sales fs
    INNER JOIN gold.dim_customers dc ON fs.customer_key = dc.customer_key
    WHERE fs.order_date IS NOT NULL
),

customer_aggregation AS (
    SELECT customer_key,
           customer_number,
           customer_name,
           age,
           COUNT(DISTINCT order_number)                                    AS total_order,
           SUM(sales_amount)                                               AS total_sales,
           SUM(quantity)                                                   AS total_quantity,
           COUNT(product_key)                                              AS total_product,
           MAX(order_date)                                                 AS last_order_date,
           (EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
            EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date)))) + 1 AS lifespan_months
    FROM base_query
    GROUP BY customer_key, customer_number, customer_name, age
)

SELECT customer_key,
       customer_number,
       customer_name,
       age,
       -- Segmentazione Fasce d'Età
       CASE
           WHEN age < 20 THEN 'Under 20'
           WHEN age BETWEEN 20 AND 29 THEN '20-29'
           WHEN age BETWEEN 30 AND 39 THEN '30-39'
           WHEN age BETWEEN 40 AND 49 THEN '40-49'
           ELSE '50 and above'
       END AS age_group,
       -- Segmentazione Valore Cliente
       CASE
           WHEN lifespan_months >= 12 AND total_sales > 5000 THEN '1. VIP'
           WHEN lifespan_months >= 12 THEN '2. Regular'
           ELSE '3. New'
       END AS customer_segment,
       last_order_date,
       -- KPI: Recency (Mesi dall'ultimo ordine)
       (EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_order_date)) * 12 +
        EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_order_date))) AS recency,
       total_order,
       total_sales,
       total_quantity,
       total_product,
       lifespan_months,
       -- KPI: Valore Medio Ordine (AOV)
       ROUND(total_sales / NULLIF(total_order, 0), 2) AS avg_order_value,
       -- KPI: Spesa Media Mensile
       ROUND(total_sales / NULLIF(lifespan_months, 0), 2) AS avg_monthly_spent
FROM customer_aggregation;