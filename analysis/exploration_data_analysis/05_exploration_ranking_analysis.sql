/*
===============================================================================
Analisi del Ranking (Top & Bottom Performers)
Obiettivo: Ordinare i valori di una Dimensione in base a una Misura.
Perché: Permette di identificare rapidamente i "Top N" (i migliori) e i
       "Bottom N" (i peggiori).
Esempio: "Chi sono i 5 clienti che spendono di più?"
         "Quali sono i 3 prodotti meno venduti?"
===============================================================================
*/

-- Quali sono i 5 prodotti che generano il fatturato più elevato?
SELECT product_name,
       SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
         LEFT JOIN gold.dim_products dp on fs.product_key = dp.product_key
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 5;
-- alternativa
SELECT *
FROM (SELECT product_name,
             SUM(fs.sales_amount)                                   AS total_revenue,
             DENSE_RANK() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS rank_products
      FROM gold.fact_sales fs
               LEFT JOIN gold.dim_products dp on fs.product_key = dp.product_key
      GROUP BY product_name) t
WHERE rank_products <= 5;


-- Quali sono i 5 prodotti con le vendite peggiori?
SELECT product_name,
       SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
         LEFT JOIN gold.dim_products dp on fs.product_key = dp.product_key
GROUP BY product_name
ORDER BY total_revenue
LIMIT 5;
-- alternativa
SELECT *
FROM (SELECT product_name,
             SUM(fs.sales_amount)                              AS total_revenue,
             DENSE_RANK() OVER (ORDER BY SUM(fs.sales_amount)) AS rank_products
      FROM gold.fact_sales fs
               LEFT JOIN gold.dim_products dp on fs.product_key = dp.product_key
      GROUP BY product_name) t
WHERE rank_products <= 5;

-- Trova i 10 clienti che hanno generato il fatturato più alto
SELECT dc.customer_key,
       dc.first_name,
       dc.last_name,
       SUM(sales_amount) AS total_revenue
FROM gold.fact_sales fs
         LEFT JOIN gold.dim_customers dc ON dc.customer_key = fs.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Trova i 3 clienti con il minor numero di ordini effettuati
SELECT dc.customer_key,
       dc.first_name,
       dc.last_name,
       COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales fs
         LEFT JOIN gold.dim_customers dc ON dc.customer_key = fs.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY total_orders
LIMIT 3;
