/* ===============================================================================
TABELLA: crm_cust_info
===============================================================================
*/

/* ===============================================================================
1. Controllo Integrità: cst_id (Formato e Valori Nulli)
===============================================================================
*/
SELECT *
FROM bronze.crm_cust_info
WHERE cst_id IS NULL
   OR cst_id::TEXT !~ '^[0-9]+$';

/* ===============================================================================
2. Controllo Logico: cst_id (Primary Key Duplicate)
===============================================================================
*/
SELECT cst_id,
       COUNT(*) as conteggio
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL;

/* ===============================================================================
3. Controllo Pulizia: Spazi Vuoti (Leading/Trailing Spaces)
===============================================================================
*/
SELECT cst_key, cst_firstname, cst_lastname
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key)
   OR cst_firstname != TRIM(cst_firstname)
   OR cst_lastname != TRIM(cst_lastname);

/* ===============================================================================
4. Controllo Standardizzazione: Gender e Marital Status
===============================================================================
*/
SELECT DISTINCT cst_gndr FROM bronze.crm_cust_info;
SELECT DISTINCT cst_marital_status FROM bronze.crm_cust_info;


/* ===============================================================================
TABELLA: crm_prd_info
===============================================================================
*/

/* ===============================================================================
1. Controllo Integrità: prd_id (Primary Key)
===============================================================================
*/
SELECT *
FROM bronze.crm_prd_info
WHERE prd_id IS NULL
   OR prd_id::TEXT !~ '^[0-9]+$';

/* ===============================================================================
2. Controllo Logico: prd_id (Duplicati)
===============================================================================
*/
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

/* ===============================================================================
3. Controllo Pulizia: Spazi Bianchi e Nomi
===============================================================================
*/
SELECT prd_key, prd_nm FROM bronze.crm_prd_info
WHERE prd_key != TRIM(prd_key) OR prd_nm != TRIM(prd_nm);

/* ===============================================================================
4. Controllo Consistenza: prd_cost (NULL o Negativi)
===============================================================================
*/
SELECT * FROM bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

/* ===============================================================================
5. Controllo Standardizzazione: prd_line (Codici Linea Prodotto)
===============================================================================
*/
SELECT DISTINCT prd_line FROM bronze.crm_prd_info;

/* ===============================================================================
6. Controllo Logico Anomalia Date: (Fine < Inizio)
===============================================================================
*/
SELECT prd_id, prd_nm, prd_start_dt, prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_start_dt::DATE > prd_end_dt::DATE;

/* ===============================================================================
7. TEST LOGICA SILVER: Estrazione Cat_ID e Key
===============================================================================
*/
SELECT
    prd_key AS original,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id_test,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key_test
FROM bronze.crm_prd_info;

/* ===============================================================================
8. TEST LOGICA SILVER: Ricalcolo Date (LEAD)
===============================================================================
*/
SELECT
    prd_key,
    prd_start_dt::DATE as start_dt,
    prd_end_dt::DATE as end_dt_originale,
    (LEAD(prd_start_dt::DATE) OVER (PARTITION BY prd_key ORDER BY prd_start_dt::DATE) - INTERVAL '1 day')::DATE as end_dt_ricalcolata
FROM bronze.crm_prd_info;

/* ===============================================================================
9. Controllo Integrità Referenziale: Categorie Prodotto
===============================================================================
*/
SELECT DISTINCT
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id_estratto
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN (
    SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2
);


/* ===============================================================================
TABELLA: crm_sales_details
===============================================================================
*/

/* ===============================================================================
1. Controllo Integrità: IDs (Prodotto e Cliente)
===============================================================================
*/
SELECT * FROM bronze.crm_sales_details
WHERE sls_prd_key IS NULL OR sls_cust_id IS NULL;

/* ===============================================================================
2. Controllo Logico: Formato Date (YYYYMMDD)
===============================================================================
*/
SELECT sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt = 0
   OR LENGTH(sls_order_dt::TEXT) != 8;

/* ===============================================================================
3. Controllo Consistenza: Calcolo Totale Vendite
===============================================================================
*/
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_sales    AS valore_bronze,
    sls_quantity AS qty,
    sls_price    AS prezzo_bronze,
    (sls_quantity * ABS(sls_price)) AS calcolo_corretto,
    (sls_sales - (sls_quantity * ABS(sls_price))) AS discrepanza
FROM bronze.crm_sales_details
WHERE
    sls_sales != (sls_quantity * ABS(sls_price))
    OR sls_sales IS NULL
    OR sls_quantity IS NULL
    OR sls_price IS NULL
    OR sls_sales <= 0
    OR sls_quantity <= 0;


/* ===============================================================================
TABELLA: erp_cust_az12
===============================================================================
*/

/* ===============================================================================
1. Controllo Pulizia: Prefisso 'NAS' in cid
===============================================================================
Obiettivo: Identificare i record che hanno il prefisso 'NAS' da rimuovere.
===============================================================================
*/
SELECT cid
FROM bronze.erp_cust_az12
WHERE cid LIKE 'NAS%';

/* ===============================================================================
2. Controllo Logico: Date di Nascita Future
===============================================================================
Obiettivo: Verificare se ci sono date di nascita oltre la data odierna.
===============================================================================
*/
SELECT cid, bdate
FROM bronze.erp_cust_az12
WHERE bdate > CURRENT_DATE;

/* ===============================================================================
3. Controllo Standardizzazione: Gender (Distinct Values)
===============================================================================
*/
SELECT DISTINCT gen FROM bronze.erp_cust_az12;


/* ===============================================================================
TABELLA: erp_loc_a101
===============================================================================
*/

/* ===============================================================================
1. Controllo Pulizia: Caratteri Speciali (Trattini in cid)
===============================================================================
*/
SELECT cid
FROM bronze.erp_loc_a101
WHERE cid LIKE '%-%';

/* ===============================================================================
2. Controllo Standardizzazione: Paesi (Country Codes)
===============================================================================
Obiettivo: Trovare codici nazione non espansi o valori nulli/vuoti.
===============================================================================
*/
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101;


/* ===============================================================================
TABELLA: erp_px_cat_g1v2
===============================================================================
*/

/* ===============================================================================
1. Controllo Pulizia: Spazi Bianchi (Trim Check)
===============================================================================
*/
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

/* ===============================================================================
2. Controllo Integrità: Valori Nulli in Colonne Chiave
===============================================================================
*/
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE id IS NULL OR cat IS NULL OR subcat IS NULL;