/*
===============================================================================
ESPLORAZIONE DELLE MISURE
Obiettivo: Calcolare l'indicatore chiave dell'azienda (Grandi numeri)
Massimo livello di aggregazione | Minimo livello di dettaglio
===============================================================================
*/

-- Calcola il totale delle vendite
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value
FROM gold.fact_sales
UNION ALL
-- Calcola quanti articoli sono stati venduti
SELECT 'Total Quantity', SUM(quantity)
FROM gold.fact_sales
UNION ALL
-- Calcola il prezzo medio di vendita
SELECT 'Average Prince', AVG(unit_price)::numeric(10, 2)
FROM gold.fact_sales
UNION ALL
-- Calcola il numero totale di ordini
SELECT 'Total Orders', COUNT(DISTINCT order_number)
FROM gold.fact_sales
UNION ALL
-- Calcola il numero totale di prodotti
SELECT 'Total Products', COUNT(product_key)
FROM gold.dim_products
UNION ALL
-- Calcola il numero totale di clienti
SELECT 'Total Customer', COUNT(customer_key)
FROM gold.dim_customers
UNION ALL
-- Calcola il numero totale di clienti che hanno effettuato un ordine
SELECT 'Total Customer with an Order', COUNT(DISTINCT customer_key)
FROM gold.fact_sales;

