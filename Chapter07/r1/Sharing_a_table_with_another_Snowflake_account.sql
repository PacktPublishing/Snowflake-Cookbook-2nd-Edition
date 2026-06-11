--provider account: create database and transactions table
CREATE DATABASE C7_R1;

USE DATABASE C7_R1;
USE WAREHOUSE DEFAULT_WH;

CREATE TABLE TRANSACTIONS
(
    TXN_ID STRING,
    TXN_DATE DATE,
    CUSTOMER_ID STRING,
    QUANTITY DECIMAL(20),
    PRICE DECIMAL(30,2),
    COUNTRY_CD STRING
);

--provider account: populate the table with sample data
INSERT INTO TRANSACTIONS
SELECT
    UUID_STRING() AS TXN_ID,
    DATEADD(DAY, UNIFORM(1, 500, RANDOM()) * -1, '2020-10-15') AS TXN_DATE,
    UUID_STRING() AS CUSTOMER_ID,
    UNIFORM(1, 10, RANDOM()) AS QUANTITY,
    UNIFORM(1, 200, RANDOM()) AS PRICE,
    RANDSTR(2, RANDOM()) AS COUNTRY_CD
FROM TABLE(GENERATOR(ROWCOUNT => 1000));

--provider account: create the share
USE ROLE ACCOUNTADMIN;

CREATE SHARE SHARE_TRX_DATA;

--provider account: grant database and schema usage to the share
GRANT USAGE ON DATABASE C7_R1 TO SHARE SHARE_TRX_DATA;
GRANT USAGE ON SCHEMA C7_R1.PUBLIC TO SHARE SHARE_TRX_DATA;

--provider account: grant SELECT on the shared table
GRANT SELECT ON TABLE C7_R1.PUBLIC.TRANSACTIONS TO SHARE SHARE_TRX_DATA;

--consumer account: retrieve the consumer account locator if needed
SELECT CURRENT_ACCOUNT();

--provider account: add the consumer account to the share
ALTER SHARE SHARE_TRX_DATA
ADD ACCOUNT = <consumer_account_locator_here>;

--consumer account: list available shares
USE ROLE ACCOUNTADMIN;

SHOW SHARES;

--consumer account: describe the inbound share
DESC SHARE <provider_account_locator_here>.SHARE_TRX_DATA;

--consumer account: create a database from the share
CREATE DATABASE SHR_TRANSACTIONS
FROM SHARE <provider_account_locator_here>.SHARE_TRX_DATA;

--consumer account: validate the database is attached to the share
DESC SHARE <provider_account_locator_here>.SHARE_TRX_DATA;

--consumer account: query the shared table
SELECT *
FROM SHR_TRANSACTIONS.PUBLIC.TRANSACTIONS;
