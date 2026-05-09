--create and set the database
CREATE DATABASE C3_R4;
USE C3_R4;

--create the target table
CREATE OR REPLACE TABLE TRANSACTIONS
(
    TRANSACTION_DATE DATE,
    CUSTOMER_ID NUMBER(38,0),
    TRANSACTION_ID NUMBER(38,0),
    AMOUNT NUMBER(38,0)
);

--create a reusable Parquet file format
CREATE OR REPLACE FILE FORMAT GEN_PARQ
    TYPE = PARQUET
    COMPRESSION = AUTO
    NULL_IF = ('MISSING','');

--create an external stage for the Parquet files
CREATE OR REPLACE STAGE C3_R4_STAGE
    URL = 's3://snowflake-cookbook/Chapter03/r4'
    FILE_FORMAT = GEN_PARQ;

--list files in the stage
LIST @C3_R4_STAGE;

--preview the Parquet data from the stage
SELECT $1 FROM @C3_R4_STAGE;

--insert selected Parquet fields into the relational target table
INSERT INTO TRANSACTIONS
SELECT
    $1:_COL_0::DATE,
    $1:_COL_1::NUMBER,
    $1:_COL_2::NUMBER,
    $1:_COL_3::NUMBER
FROM @C3_R4_STAGE;

--verify the loaded data
USE C3_R4;
SELECT * FROM TRANSACTIONS;
