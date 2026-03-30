/*
===============================================================================
08_ddl_gold.sql
Layer: Gold
Obiettivo: Definizione delle Dimensioni (Star Schema)
===============================================================================
*/

-- =============================================================================
-- Tabella: gold.dim_customers
-- Tipo: Dimension (SCD Type 0/1)
-- Logica:
--     - Unisce i dati anagrafici del CRM con i dettagli ERP (genere, nazione, nascita).
--     - Applica la Master Data Management (MDM): il CRM è la fonte primaria.
--     - Genera una Surrogate Key tramite ROW_NUMBER().
-- =============================================================================

CREATE OR REPLACE VIEW gold.dim_customers AS
SELECT
    -- 1. Generazione Surrogate Key (ID unico interno del DW)
    ROW_NUMBER() OVER (ORDER BY ci.cst_key) AS customer_key,

    -- 2. Chiavi Naturali e Attributi Identificativi
    ci.cst_id                               AS customer_id,
    ci.cst_key                              AS customer_number,
    ci.cst_firstname                        AS first_name,
    ci.cst_lastname                         AS last_name,

    -- 3. Integrazione Dati (Master Logic)
    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
        END                                 AS gender,

    COALESCE(la.cntry, 'n/a')               AS country,
    ci.cst_marital_status                   AS marital_status,
    ca.bdate                                AS birthdate,
    ci.cst_create_date                      AS create_date

FROM silver.crm_cust_info ci
         LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
         LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid;


-- =============================================================================
-- Tabella: gold.dim_products
-- Tipo: Dimension
-- Logica:
--     - Unisce i prodotti del CRM con le categorie dell'ERP.
--     - Genera una Surrogate Key (product_key) partendo da 1.
--     - Filtra i record storici mantenendo solo quelli correnti (end_dt IS NULL).
-- =============================================================================

CREATE OR REPLACE VIEW gold.dim_products AS
SELECT
    -- 1. Generazione Surrogate Key
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,

    -- 2. Chiavi Naturali
    pn.prd_id                                                AS product_id,
    pn.prd_key                                               AS product_number,

    -- 3. Attributi Prodotto
    pn.prd_nm                                                AS product_name,
    pn.cat_id                                                AS category_id,
    pc.cat                                                   AS category,
    pc.subcat                                                AS subcategory,
    pc.maintenance                                           AS maintenance,

    -- 4. Attributi Storici e Finanziari
    pn.prd_cost                                              AS cost,
    pn.prd_line                                              AS product_line,
    pn.prd_start_dt                                          AS start_date

FROM silver.crm_prd_info pn
         LEFT JOIN silver.erp_px_cat_g1v2 pc ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; -- Manteniamo solo i prodotti attivi

-- =============================================================================
-- Tabella: gold.fact_sales
-- Tipo: Fact Table
-- Logica:
--     - Contiene tutte le transazioni di vendita dal CRM.
--     - Collega le vendite alle dimensioni (Customer e Product) tramite Surrogate Keys.
--     - Recupera le chiavi surrogate tramite JOIN con le View Gold.
-- =============================================================================

CREATE OR REPLACE VIEW gold.fact_sales AS
SELECT
    -- 1. Identificativi Transazione
    sd.sls_ord_num    AS order_number,

    -- 2. Surrogate Keys (Il collegamento allo Star Schema)
    pr.product_key    AS product_key,
    cu.customer_key   AS customer_key,

    -- 3. Date
    sd.sls_order_dt   AS order_date,
    sd.sls_ship_dt    AS shipping_date,
    sd.sls_due_dt     AS due_date,

    -- 4. Metriche e Misure (I "Fatti" numerici)
    sd.sls_sales      AS sales_amount,
    sd.sls_quantity   AS quantity,
    sd.sls_price      AS unit_price

FROM silver.crm_sales_details sd
-- Colleghiamo i prodotti usando la Natural Key (product_number)
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
-- Colleghiamo i clienti usando la Natural Key (customer_id)
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;