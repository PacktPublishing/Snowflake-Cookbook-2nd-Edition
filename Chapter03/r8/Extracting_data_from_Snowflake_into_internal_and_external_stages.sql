--create and set the database
CREATE DATABASE EXPORT_EX;
USE DATABASE EXPORT_EX;

--create an internal stage for exports
CREATE OR REPLACE STAGE EXPORT_INTERNAL_STG 
FILE_FORMAT = (TYPE = CSV COMPRESSION = GZIP);

--export sample data into the internal stage
COPY INTO @EXPORT_INTERNAL_STG/customer.csv.gz 
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

--verify exported files
LIST @EXPORT_INTERNAL_STG;

--download files from the internal stage using Snowflake CLI
--run this command from your operating system command line
--snow stage copy @EXPORT_INTERNAL_STG file://C:/Downloads/;

--create an external stage for exporting to S3
--replace <bucket> with your actual bucket name
CREATE OR REPLACE STAGE EXPORT_EXTERNAL_STG
URL = 's3://<bucket>'
STORAGE_INTEGRATION = S3_INTEGRATION
FILE_FORMAT = (TYPE = PARQUET COMPRESSION = AUTO);

--export query results into the external stage
COPY INTO @EXPORT_EXTERNAL_STG/customer.parquet 
FROM (
    SELECT *
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER SAMPLE (10)
);
