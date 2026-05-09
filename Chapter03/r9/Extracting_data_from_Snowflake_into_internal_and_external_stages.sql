--create and set the export database
CREATE DATABASE EXPORT_EX;
USE DATABASE EXPORT_EX;

--create an internal stage for CSV export
CREATE OR REPLACE STAGE EXPORT_INTERNAL_STG
    FILE_FORMAT = (TYPE = CSV COMPRESSION = GZIP);

--unload data from a table into the internal stage
COPY INTO @EXPORT_INTERNAL_STG/customer.csv.gz
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

--list exported files in the internal stage
LIST @EXPORT_INTERNAL_STG;

--download exported files from the internal stage to a local directory
GET @EXPORT_INTERNAL_STG 'file://C:/Downloads/';

--create an external stage for Parquet export
CREATE OR REPLACE STAGE EXPORT_EXTERNAL_STG
    URL = 's3://<bucket>'
    STORAGE_INTEGRATION = S3_INTEGRATION
    FILE_FORMAT = (TYPE = PARQUET COMPRESSION = AUTO);

--unload the results of a query into the external stage
COPY INTO @EXPORT_EXTERNAL_STG/customer.parquet
FROM (
    SELECT *
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER SAMPLE (10)
);
