--create a database and source table for the Dynamic Table
CREATE OR REPLACE DATABASE STREAM_DEMO;
USE DATABASE STREAM_DEMO;

CREATE OR REPLACE TABLE CUSTOMER_STAGING_DT
(
    ID INTEGER,
    NAME STRING,
    STATE STRING,
    COUNTRY STRING
);

--insert initial source data
INSERT INTO CUSTOMER_STAGING_DT VALUES
(1, 'JANE DOE', 'NSW', 'AU'),
(2, 'ALPHA', 'VIC', 'AU');

--create a Dynamic Table based on the source table
CREATE OR REPLACE DYNAMIC TABLE CUSTOMER_DT
    TARGET_LAG = '1 MINUTE'
    WAREHOUSE = COMPUTE_WH
    REFRESH_MODE = AUTO
AS
SELECT
    ID,
    NAME,
    STATE,
    COUNTRY
FROM CUSTOMER_STAGING_DT;

--query the Dynamic Table
SELECT *
FROM CUSTOMER_DT;

--insert additional source data
INSERT INTO CUSTOMER_STAGING_DT VALUES
(3, 'MIKE', 'ACT', 'AU'),
(4, 'TANGO', 'NT', 'AU');

--query the Dynamic Table after refresh
SELECT *
FROM CUSTOMER_DT;

--inspect Dynamic Table refresh history
SELECT *
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY());
