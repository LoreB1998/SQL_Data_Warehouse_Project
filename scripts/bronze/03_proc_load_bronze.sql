/*
===============================================================================
Stored Procedure: Load bronze Layer (Source -> bronze)
===============================================================================
Script Purpose:
    Questa stored procedure carica i dati nel layer 'bronze' dai file CSV esterni.
    Esegue le seguenti azioni:
    - Svuota le tabelle bronze (TRUNCATE) prima del caricamento.
    - Utilizza il comando 'COPY' per importare i dati dai file CSV nelle tabelle.
    - Calcola la durata del caricamento per ogni singola tabella e per l'intero batch.
    - Gestisce eventuali errori durante il processo tramite un blocco EXCEPTION.

Parameters:
    Nessuno.
    Questa stored procedure non accetta parametri e non restituisce valori.

Usage Example:
    CALL bronze.load_bronze();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_batch_start_time TIMESTAMP;
    v_batch_end_time TIMESTAMP;
BEGIN
    v_batch_start_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading bronze Layer';
    RAISE NOTICE '================================================';

    -- ------------------------------------------------
    -- Loading CRM Tables
    -- ------------------------------------------------
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------------------------';

    -- Table: bronze.crm_cust_info
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;
    RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
    EXECUTE 'COPY bronze.crm_cust_info FROM ''/Users/lorenzo/Desktop/SQL/SQL_Data_Warehouse_Project/datasets/source_crm/cust_info.csv'' WITH (FORMAT csv, HEADER true, DELIMITER '','', ENCODING ''UTF8'')';
    v_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_end_time - v_start_time;

    -- Table: bronze.crm_prd_info
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;
    RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
    EXECUTE 'COPY bronze.crm_prd_info FROM ''/Users/lorenzo/Desktop/SQL/SQL_Data_Warehouse_Project/datasets/source_crm/prd_info.csv'' WITH (FORMAT csv, HEADER true, DELIMITER '','', ENCODING ''UTF8'')';
    v_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_end_time - v_start_time;

    -- Table: bronze.crm_sales_details
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;
    RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
    EXECUTE 'COPY bronze.crm_sales_details FROM ''/Users/lorenzo/Desktop/SQL/SQL_Data_Warehouse_Project/datasets/source_crm/sales_details.csv'' WITH (FORMAT csv, HEADER true, DELIMITER '','', ENCODING ''UTF8'')';
    v_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_end_time - v_start_time;

    -- ------------------------------------------------
    -- Loading ERP Tables
    -- ------------------------------------------------
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------------------------';

    -- Table: bronze.erp_loc_a101
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101;
    RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
    EXECUTE 'COPY bronze.erp_loc_a101 FROM ''/Users/lorenzo/Desktop/SQL/SQL_Data_Warehouse_Project/datasets/source_erp/LOC_A101.csv'' WITH (FORMAT csv, HEADER true, DELIMITER '','', ENCODING ''UTF8'')';
    v_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_end_time - v_start_time;

    -- Table: bronze.erp_cust_az12
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;
    RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
    EXECUTE 'COPY bronze.erp_cust_az12 FROM ''/Users/lorenzo/Desktop/SQL/SQL_Data_Warehouse_Project/datasets/source_erp/CUST_AZ12.csv'' WITH (FORMAT csv, HEADER true, DELIMITER '','', ENCODING ''UTF8'')';
    v_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_end_time - v_start_time;

    -- Table: bronze.erp_px_cat_g1v2
    v_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
    EXECUTE 'COPY bronze.erp_px_cat_g1v2 FROM ''/Users/lorenzo/Desktop/SQL/SQL_Data_Warehouse_Project/datasets/source_erp/PX_CAT_G1V2.csv'' WITH (FORMAT csv, HEADER true, DELIMITER '','', ENCODING ''UTF8'')';
    v_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_end_time - v_start_time;

    v_batch_end_time := clock_timestamp();
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Loading bronze Layer is Completed';
    RAISE NOTICE '   - Total Load Duration: %', v_batch_end_time - v_batch_start_time;
    RAISE NOTICE '==========================================';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'ERROR OCCURED DURING LOADING BRONZE LAYER';
    RAISE NOTICE 'Error Message: %', SQLERRM;
    RAISE NOTICE '==========================================';
END;
$$;

CALL bronze.load_bronze();

SELECT COUNT(*) FROM bronze.crm_cust_info;

SELECT COUNT(*)
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL;