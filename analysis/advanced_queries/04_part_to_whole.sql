/*
===============================================================================
Analisi Parte-Tutto (Part-to-Whole / Proportional Analysis)
Obiettivo: Analizzare la performance di una singola categoria rispetto al totale.
Perché: Permette di capire l'impatto relativo di ogni segmento (es. categorie,
        regioni, prodotti) sul business complessivo.
Esempio: "Quale categoria di prodotti genera la maggior parte del fatturato?"
         "Che percentuale delle vendite totali proviene dal mercato Europeo?"
===============================================================================
*/

-- Quali categorie contribuiscono maggiormente tra tutte le vendite?
WITH category_sales AS (
    SELECT
        dp.category,
        SUM(fs.sales_amount) AS sales_by_category
    FROM gold.fact_sales fs
    LEFT JOIN gold.dim_products dp ON fs.product_key = dp.product_key
    WHERE dp.category IS NOT NULL
    GROUP BY dp.category
)
SELECT
    category,
    sales_by_category,
    SUM(sales_by_category) OVER() AS total_sales,
    ROUND((sales_by_category * 100.0 / SUM(sales_by_category) OVER()), 2) || '%' AS pct_sales
FROM category_sales
ORDER BY sales_by_category DESC;