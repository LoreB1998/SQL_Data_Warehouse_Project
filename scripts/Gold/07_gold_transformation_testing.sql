/*
===============================================================================
07_gold_transformation_testing.sql
Layer: Gold (Validation)
Obiettivo: Verificare l'integrità e la coerenza dei dati prima della creazione delle VIEW Gold.
===============================================================================
*/

/* ===============================================================================
1. CUSTOMER DIMENSION VALIDATION
===============================================================================
Obiettivo: Verificare l'integrazione tra CRM e ERP (AZ12 e LOC101).
===============================================================================
*/

-- Controllo Base: Anteprima dell'unione delle fonti Silver
SELECT ci.cst_id,
       ci.cst_key,
       ci.cst_firstname,
       ci.cst_lastname,
       ci.cst_marital_status,
       ci.cst_gndr,
       ci.cst_create_date,
       ca.gen,
       ca.bdate,
       la.cntry
FROM silver.crm_cust_info ci
         LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
         LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid;

-- Unicità Primary Key: Verifica se l'integrazione genera duplicati di cst_id
SELECT cst_id, COUNT(*)
FROM (SELECT ci.cst_id
      FROM silver.crm_cust_info ci
               LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
               LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid) t
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Test Logica MDM (Master Data Management) per il Genere:
-- Verifichiamo come si combinano i valori CRM e ERP.
SELECT DISTINCT ci.cst_gndr,
                ca.gen
FROM silver.crm_cust_info ci
         LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
         LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid
ORDER BY 1, 2;

-- Test Trasformazione Finale: Applicazione della priorità al CRM
SELECT DISTINCT ci.cst_gndr,
                ca.gen,
                CASE
                    WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM è la master source
                    ELSE COALESCE(ca.gen, 'n/a')
                    END as gender
FROM silver.crm_cust_info ci
         LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
         LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid
ORDER BY 1, 2;

-- Verifica finale sulla View Gold già creata
SELECT DISTINCT gender
FROM gold.dim_customers;


/* ===============================================================================
2. PRODUCT DIMENSION VALIDATION
===============================================================================
Obiettivo: Verificare l'unione tra Prodotti CRM e Categorie ERP.
===============================================================================
*/

-- Controllo Base: JOIN tra prodotti Silver e categorie ERP
SELECT pn.prd_id,
       pn.cat_id,
       pn.prd_key,
       pn.prd_nm,
       pn.prd_cost,
       pn.prd_line,
       pn.prd_start_dt,
       pc.cat,
       pc.subcat,
       pc.maintenance
FROM silver.crm_prd_info pn
         LEFT JOIN silver.erp_px_cat_g1v2 pc ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; -- Solo prodotti attivi

-- Unicità Primary Key: Verifica duplicati su prd_id nella dimensione finale
SELECT prd_id, COUNT(*)
FROM (SELECT pn.prd_id
      FROM silver.crm_prd_info pn
               LEFT JOIN silver.erp_px_cat_g1v2 pc ON pn.cat_id = pc.id
      WHERE pn.prd_end_dt IS NULL
     ) t
GROUP BY prd_id
HAVING count(*) > 1;

-- Verifica finale sulla View Gold dei Prodotti
SELECT *
FROM gold.dim_products;


/* ===============================================================================
3. SALES FACT VALIDATION (DATA LOOKUP)
===============================================================================
Obiettivo: Garantire che ogni vendita possa collegarsi correttamente alle dimensioni Gold.
===============================================================================
*/

-- Test di Lookup: Verifichiamo se otteniamo correttamente le Surrogate Keys (customer_key, product_key)
-- Se queste chiavi sono NULL, significa che c'è un problema di integrità referenziale.
SELECT sd.sls_ord_num,
       pr.product_key,
       cu.customer_key,
       sd.sls_order_dt,
       sd.sls_ship_dt,
       sd.sls_due_dt,
       sd.sls_sales,
       sd.sls_quantity,
       sd.sls_price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu ON sd.sls_cust_id = cu.customer_id;

/* ===============================================================================
4. FOREIGN KEY INTEGRITY CHECK (VENDITE ORFANE)
===============================================================================
Obiettivo: Verificare che ogni record nella Fact Table abbia una corrispondenza
           nelle tabelle delle Dimensioni.
===============================================================================
*/

-- Controllo Integrità: Clienti
-- Cerchiamo vendite che NON hanno un cliente corrispondente nel Gold
SELECT
    f.order_number,
    f.customer_key,
    c.customer_key AS dim_customer_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL;

-- Controllo Integrità: Prodotti
-- Cerchiamo vendite che NON hanno un prodotto corrispondente nel Gold
SELECT
    f.order_number,
    f.product_key,
    p.product_key AS dim_product_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL;