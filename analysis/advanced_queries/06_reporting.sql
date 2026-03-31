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
/*---------------------------------------------------------------------------
1) Base Query: Estrazione dati da fact_sales e dim_customers
---------------------------------------------------------------------------*/
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
    WHERE fs.order_date IS NOT NULL  -- Consideriamo solo vendite valide
),

customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregation: Sintesi delle metriche a livello di cliente
---------------------------------------------------------------------------*/
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

/*---------------------------------------------------------------------------
3) Final Query: Calcolo dei KPI e Segmentazione
---------------------------------------------------------------------------*/
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
       -- KPI: Recency (mesi dall'ultimo ordine)
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

/*
===============================================================================
REPORT PRODOTTI (Product Report)
===============================================================================
Scopo:
    - Questo report consolida le metriche chiave e le performance dei prodotti.

Punti salienti:
    1. Raccoglie campi essenziali come nome prodotto, categoria, sottocategoria e costo.
    2. Aggrega metriche a livello di prodotto:
        - ordini totali
        - vendite totali
        - quantità totale venduta
        - clienti totali (unici che hanno acquistato il prodotto)
        - lifespan (longevità del prodotto in mesi nel catalogo)
    3. Segmentazione dei prodotti in categorie (High-Performer, Mid-Range, Low-Performer).
    4. Calcola KPI di valore:
        - recency (mesi dall'ultima vendita)
        - ricavo medio per ordine (AOR)
        - ricavo medio mensile
===============================================================================
*/
CREATE VIEW gold.report_products AS
WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Estrazione dati da fact_sales e dim_products
---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL  -- Consideriamo solo vendite valide
),

product_aggregations AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Sintesi delle metriche a livello di prodotto
---------------------------------------------------------------------------*/
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        (EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
         EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date)))) + 1 AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        -- Prezzo medio di vendita (evitiamo divisione per zero)
        ROUND(AVG(sales_amount::numeric / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

/*---------------------------------------------------------------------------
3) Final Query: Calcolo dei KPI e Segmentazione
---------------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    -- KPI: Recency (mesi dall'ultima vendita)
    (EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_sale_date)) * 12 +
     EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_sale_date))) AS recency_in_months,
    -- Segmentazione Valore Prodotto
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    -- KPI: Ricavo Medio per Ordine (AOR)
    ROUND(total_sales::numeric / NULLIF(total_orders, 0), 2) AS avg_order_revenue,
    -- KPI: Ricavo Medio Mensile
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE ROUND(total_sales::numeric / lifespan, 2)
    END AS avg_monthly_revenue
FROM product_aggregations;