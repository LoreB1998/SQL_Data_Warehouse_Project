/*
=======================================================================
Create Database and Schemas
=======================================================================
Script Purpose:
    This script creates a new database named 'datawarehouse' and
    sets up three distinct schemas within it: 'bronze', 'silver',
    and 'gold', following the Medallion Architecture.

WARNING:
    If the database 'datawarehouse' already exists, ensure you are
    connected to the correct instance. All schemas created will be
    empty and ready for data ingestion. Proceed with caution.
=======================================================================
*/

-- Creazione del database (eseguire separatamente se necessario)
CREATE DATABASE datawarehouse;

-- Creazione degli schemi bronze, silver e gold
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;



