/*
===============================================================================
Analisi dell'Evoluzione Temporale (Change-Over-Time / Trends)
Obiettivo: Analizzare come una misura (es. Sales) si evolve nel tempo.
Perché: Permette di tracciare i trend di crescita, identificare la stagionalità
        (picchi e cali in certi mesi) e prevedere l'andamento futuro.
Esempio: "Le vendite stanno aumentando mese dopo mese?"
         "C'è un calo ricorrente ogni anno a Febbraio?"
===============================================================================
*/
-- By Year
-- Performance delle vendite nel tempo (anni)
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
       SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- Numero di clienti nel tempo (anni)
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
       COUNT(DISTINCT customer_key) AS total_customer
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- Volume di vendite nel tempo (anni)
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
       COUNT(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- By Month
-- Performance delle vendite nel tempo (mesi)
-- Numero di clienti nel tempo (mesi)
-- Volume di vendite nel tempo (mesi)
SELECT EXTRACT(month FROM order_date) AS order_month,
       SUM(sales_amount) AS total_sales,
       COUNT(DISTINCT customer_key) AS total_customer,
       COUNT(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- By Month-Year
-- Performance delle vendite nel tempo (mese-anno)
-- Numero di clienti nel tempo (mese-anno)
-- Volume di vendite nel tempo (mese-anno)
SELECT to_char(order_date, 'YYYY-MM') AS order_month_year,
       SUM(sales_amount) AS total_sales,
       COUNT(DISTINCT customer_key) AS total_customer,
       COUNT(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;
