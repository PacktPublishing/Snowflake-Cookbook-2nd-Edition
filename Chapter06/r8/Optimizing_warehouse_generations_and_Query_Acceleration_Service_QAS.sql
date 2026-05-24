--create a dedicated warehouse for QAS testing
CREATE OR REPLACE WAREHOUSE WH_QAS_TEST
    WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

--set the sample data context
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCDS_SF10TCL;

--disable result caching for the session
ALTER SESSION SET USE_CACHED_RESULT = FALSE;

--use the test warehouse
USE WAREHOUSE WH_QAS_TEST;

--run a scan-heavy analytical query
SELECT
    SS_STORE_SK,
    SUM(SS_SALES_PRICE) AS TOTAL_SALES
FROM STORE_SALES
WHERE SS_SOLD_DATE_SK BETWEEN 2450815 AND 2451179
GROUP BY SS_STORE_SK
ORDER BY TOTAL_SALES DESC;

--capture the last query ID
SELECT LAST_QUERY_ID();

--estimate whether the query is eligible for Query Acceleration Service
SELECT PARSE_JSON(SYSTEM$ESTIMATE_QUERY_ACCELERATION('<query_id>'));

--enable Query Acceleration Service on the warehouse
ALTER WAREHOUSE WH_QAS_TEST
SET ENABLE_QUERY_ACCELERATION = TRUE;

--set the maximum query acceleration scale factor
ALTER WAREHOUSE WH_QAS_TEST
SET QUERY_ACCELERATION_MAX_SCALE_FACTOR = 2;

--rerun the scan-heavy analytical query after enabling QAS
SELECT
    SS_STORE_SK,
    SUM(SS_SALES_PRICE) AS TOTAL_SALES
FROM STORE_SALES
WHERE SS_SOLD_DATE_SK BETWEEN 2450815 AND 2451179
GROUP BY SS_STORE_SK
ORDER BY TOTAL_SALES DESC;

--review candidate queries for Query Acceleration Service
SELECT *
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE;
