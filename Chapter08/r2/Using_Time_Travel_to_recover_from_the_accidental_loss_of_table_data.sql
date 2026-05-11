--create a database and customer table from Snowflake sample data
CREATE DATABASE C8_R2;

CREATE TABLE CUSTOMER AS
SELECT *
FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.CUSTOMER
LIMIT 100000;

--validate the customer table data
SELECT *
FROM CUSTOMER
LIMIT 100;

--simulate accidental data loss
DELETE FROM CUSTOMER;

--validate that the table is empty
SELECT *
FROM CUSTOMER;

--query history to identify the DELETE statement
SELECT
    QUERY_ID,
    QUERY_TEXT,
    DATABASE_NAME,
    SCHEMA_NAME,
    QUERY_TYPE
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
WHERE QUERY_TYPE = 'DELETE'
  AND EXECUTION_STATUS = 'SUCCESS'
  AND DATABASE_NAME = 'C8_R2';

--query the data as it existed before the DELETE statement
SELECT *
FROM CUSTOMER BEFORE
(
    STATEMENT => '019825cd-0438-0033-0000-002fd30330bd'
);

--restore deleted rows using Time Travel
INSERT INTO CUSTOMER
SELECT *
FROM CUSTOMER BEFORE
(
    STATEMENT => '019825cd-0438-0033-0000-002fd30330bd'
);

--validate the restored data
SELECT *
FROM CUSTOMER;
