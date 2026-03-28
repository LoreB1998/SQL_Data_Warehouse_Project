/*
=======================================================================
DDL Script: Bronze Layer
=======================================================================
Script Purpose:
    Questo script crea le tabelle nel layer 'bronze' per l'ingestione
    dei dati dai sistemi sorgente ERP e CRM.
=======================================================================
*/

CREATE TABLE IF NOT EXISTS bronze.crm_cust_info
(
    cst_id             INT,         -- ID numerico principale
    cst_key            VARCHAR(50), -- Chiave alfanumerica (es. AW00011000)
    cst_firstname      VARCHAR(50), -- Nome
    cst_lastname       VARCHAR(50), -- Cognome
    cst_marital_status VARCHAR(50), -- Stato civile (M, S)
    cst_gndr           VARCHAR(50), -- Genere (M, F)
    cst_create_date    DATE         -- Data di creazione (formato YYYY-MM-DD)
);

CREATE TABLE IF NOT EXISTS bronze.crm_prd_info (
    prd_id          INT,            -- ID numerico del prodotto
    prd_key         VARCHAR(50),    -- Codice alfanumerico (es. CO-RF-FR...)
    prd_nm          VARCHAR(100),   -- Nome del prodotto (es. HL Road Frame)
    prd_cost        INT,            -- Costo (usiamo INT o NUMERIC perché nel Bronze accettiamo null)
    prd_line        VARCHAR(50),    -- Linea di prodotto (es. R, S)
    prd_start_dt    TIMESTAMP,      -- Data inizio (usiamo TIMESTAMP per flessibilità)
    prd_end_dt      TIMESTAMP       -- Data fine (può essere nulla)
);

CREATE TABLE IF NOT EXISTS bronze.crm_sales_details (
    sls_ord_num     VARCHAR(50),   -- Numero ordine (es. SO43697)
    sls_prd_key     VARCHAR(50),   -- Chiave prodotto per JOIN con prd_info
    sls_cust_id     INT,           -- ID cliente per JOIN con cust_info
    sls_order_dt    INT,           -- Data ordine in formato YYYYMMDD
    sls_ship_dt     INT,           -- Data spedizione in formato YYYYMMDD
    sls_due_dt      INT,           -- Data scadenza in formato YYYYMMDD
    sls_sales       INT,           -- Valore totale vendita
    sls_quantity    INT,           -- Quantità venduta
    sls_price       INT            -- Prezzo unitario
);

CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12 (
    cid    VARCHAR(50),  -- ID Cliente con prefisso (es. NASAW...)
    bdate  DATE,         -- Data di nascita (formato YYYY-MM-DD)
    gen    VARCHAR(50)   -- Genere (es. Male, Female)
);

CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
    cid    VARCHAR(50),  -- ID Cliente con formato (es. AW-00011...)
    cntry  VARCHAR(50)   -- Paese di residenza (es. Australia)
);

CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2 (
    id           VARCHAR(50),  -- Codice categoria/sottocategoria (es. AC_BR)
    cat          VARCHAR(50),  -- Categoria principale (es. Accessories)
    subcat       VARCHAR(50),  -- Sottocategoria (es. Bike Racks)
    maintenance  VARCHAR(50)   -- Flag manutenzione (Yes/No)
);