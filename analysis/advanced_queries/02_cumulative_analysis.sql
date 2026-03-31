/*
===============================================================================
Analisi Cumulativa (Cumulative / Running Total Analysis)
Obiettivo: Aggregare i dati progressivamente nel tempo (Giorno dopo giorno).
Perché: Permette di visualizzare la crescita totale accumulata e capire
       se il business sta accelerando o rallentando rispetto ai periodi precedenti.
Esempio: "Qual è il fatturato totale accumulato dall'inizio dell'anno ad oggi?"
===============================================================================
*/

-- Vendite cumulate (running total) per mese nel tempo (reset ogni nuovo anno)
SELECT t.order_date,
       total_sales,
       SUM(total_sales) OVER (
           PARTITION BY EXTRACT(year FROM order_date)
           ORDER BY order_date
           ) AS running_total
FROM (SELECT date_trunc('month', order_date)::DATE AS order_date,
             SUM(sales_amount)                     AS total_sales
      FROM gold.fact_sales
      WHERE order_date IS NOT NULL
      GROUP BY 1) t;

/*
===============================================================================
Confronto Trend di Prezzo: Media Semplice vs ASP (Media Ponderata)
Obiettivo: Confrontare l'impatto dei volumi di vendita sul prezzo medio.
Perché: Se l'ASP è molto più basso della Media Semplice, significa che i clienti
       stanno acquistando prevalentemente i prodotti più economici del catalogo.
===============================================================================
*/

SELECT
    t.order_date,
    -- Prezzi del mese
    t.simple_avg_price::numeric(10,2),
    t.weighted_asp_price,
    -- Media Mobile 3 mesi sulla Media Semplice
    AVG(t.simple_avg_price) OVER (
        ORDER BY t.order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    )::numeric(10,2) AS moving_avg_simple,
    -- Media Mobile 3 mesi sull'ASP (Ponderata)
    AVG(t.weighted_asp_price) OVER (
        ORDER BY t.order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    )::numeric(10,2) AS moving_avg_weighted
FROM (
    SELECT
        date_trunc('month', order_date)::DATE AS order_date,
        -- 1. Media Semplice (non tiene conto delle quantità)
        AVG(unit_price) AS simple_avg_price,
        -- 2. ASP / Media Ponderata (tiene conto delle quantità vendute)
        SUM(sales_amount) / NULLIF(SUM(quantity), 0) AS weighted_asp_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY 1
) t
ORDER BY t.order_date;