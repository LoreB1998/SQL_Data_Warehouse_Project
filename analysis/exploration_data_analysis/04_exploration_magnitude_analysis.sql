/*
===============================================================================
Analisi della Magnitudo (Magnitude Analysis)
Obiettivo: Confrontare i valori delle misure (es. Sales) tra diverse categorie.
Perché: Aiuta a identificare quali segmenti di business (prodotti, paesi, ecc.)
        hanno il peso maggiore sul risultato totale e a stabilire le priorità.
∑ [Measure] By Dimension
===============================================================================
*/

-- Qual è il numero totale di clienti per paese
SELECT country,
       COUNT(customer_key) AS total_customer
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customer DESC;

-- Qual è il numero totale di clienti per genere
SELECT gender,
       COUNT(customer_key) AS total_customer
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customer DESC;

-- Qual è il numero totale di prodotti per categoria
SELECT category,
       COUNT(product_key) AS total_product
FROM gold.dim_products
group by category
ORDER BY total_product DESC;

-- Qual è il costo medio in ciascuna categoria?
SELECT category,
       AVG(cost)::numeric(10, 2) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- Qual è il fatturato totale generato per ciascuna categoria?
SELECT category,
       SUM(sales_amount) AS total_revenue
FROM gold.fact_sales fs
         LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
GROUP BY category
ORDER BY total_revenue DESC;

-- Qual è il fatturato totale generato da ciascun cliente
SELECT dc.customer_key,
       dc.first_name,
       dc.last_name,
       SUM(sales_amount) AS total_revenue
FROM gold.fact_sales fs
         LEFT JOIN gold.dim_customers dc ON dc.customer_key = fs.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY total_revenue DESC;

-- Qual è la distribuzione degli articoli venduti nei diversi paesi?
SELECT dc.country,
       COUNT(fs.quantity) AS total_sold_items
FROM gold.fact_sales fs
         LEFT JOIN gold.dim_customers dc ON dc.customer_key = fs.customer_key
GROUP BY dc.country
ORDER BY total_sold_items DESC;