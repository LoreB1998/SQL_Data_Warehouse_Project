/*
===============================================================================
ESPLORAZIONE DEI METADATI
Obiettivo: Elencare tutti gli oggetti (Tabelle e View) creati nel database.
===============================================================================
*/

SELECT table_schema,
       table_name,
       table_type
FROM information_schema.tables
WHERE table_schema IN ('bronze', 'silver', 'gold')
ORDER BY table_schema, table_name;


/*
===============================================================================
Obiettivo: Verificare la struttura delle tabelle nel Layer gold.
Questa query elenca tutte le colonne, i tipi di dato e i vincoli di nullabilità
per garantire che lo schema rifletta fedelmente il Data Catalog.
===============================================================================
*/

SELECT table_name,
       column_name,
       data_type,
       is_nullable
FROM information_schema.columns
WHERE table_schema = 'gold'
ORDER BY table_name;



