--create a dedicated warehouse for scale testing
CREATE OR REPLACE WAREHOUSE WH_SCALE_TEST
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

--set the sample data context
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCDS_SF10TCL;

--run this query multiple times in parallel to generate concurrent workload
SELECT
    D_YEAR,
    SUM(SS_SALES_PRICE) AS TOTAL_SALES
FROM STORE_SALES
JOIN DATE_DIM
    ON STORE_SALES.SS_SOLD_DATE_SK = DATE_DIM.D_DATE_SK
GROUP BY D_YEAR
ORDER BY D_YEAR;

--optional: convert the warehouse to multi-cluster for horizontal scaling
ALTER WAREHOUSE WH_SCALE_TEST
    SET MIN_CLUSTER_COUNT = 1
        MAX_CLUSTER_COUNT = 3
        SCALING_POLICY = ECONOMY;

--optional: scale up the warehouse for more compute and memory per query
ALTER WAREHOUSE WH_SCALE_TEST
    SET WAREHOUSE_SIZE = 'MEDIUM';
