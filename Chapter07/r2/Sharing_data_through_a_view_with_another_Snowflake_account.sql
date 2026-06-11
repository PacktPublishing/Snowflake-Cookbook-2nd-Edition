--provider account: create first database and customer table
CREATE DATABASE C7_R2_DB1;
USE DATABASE C7_R2_DB1;
USE WAREHOUSE DEFAULT_WH;

CREATE TABLE CUSTOMER
(
    CUST_ID NUMBER,
    CUST_NAME STRING
);

INSERT INTO CUSTOMER
SELECT
    SEQ8() AS CUST_ID,
    RANDSTR(10, RANDOM()) AS CUST_NAME
FROM TABLE(GENERATOR(ROWCOUNT => 1000));

--provider account: create second database and customer address table
CREATE DATABASE C7_R2_DB2;
USE DATABASE C7_R2_DB2;

CREATE TABLE CUSTOMER_ADDRESS
(
    CUST_ID NUMBER,
    CUST_ADDRESS STRING
);

INSERT INTO CUSTOMER_ADDRESS
SELECT
    SEQ8() AS CUST_ID,
    RANDSTR(50, RANDOM()) AS CUST_ADDRESS
FROM TABLE(GENERATOR(ROWCOUNT => 1000));

--provider account: create database for the secure view
CREATE DATABASE VIEW_SHR_DB;
USE DATABASE VIEW_SHR_DB;

CREATE SECURE VIEW CUSTOMER_INFO AS
SELECT
    CUS.CUST_ID,
    CUS.CUST_NAME,
    CUS_ADD.CUST_ADDRESS
FROM C7_R2_DB1.PUBLIC.CUSTOMER CUS
INNER JOIN C7_R2_DB2.PUBLIC.CUSTOMER_ADDRESS CUS_ADD
    ON CUS.CUST_ID = CUS_ADD.CUST_ID;

--provider account: validate the secure view
SELECT *
FROM CUSTOMER_INFO;

--provider account: create the share
USE ROLE ACCOUNTADMIN;

CREATE SHARE SHARE_CUST_DATA;

--provider account: grant usage on the secure view database and schema
GRANT USAGE ON DATABASE VIEW_SHR_DB TO SHARE SHARE_CUST_DATA;
GRANT USAGE ON SCHEMA VIEW_SHR_DB.PUBLIC TO SHARE SHARE_CUST_DATA;

--provider account: grant reference usage on the underlying databases
GRANT REFERENCE_USAGE ON DATABASE C7_R2_DB1 TO SHARE SHARE_CUST_DATA;
GRANT REFERENCE_USAGE ON DATABASE C7_R2_DB2 TO SHARE SHARE_CUST_DATA;

--provider account: grant SELECT on the secure view
GRANT SELECT ON VIEW VIEW_SHR_DB.PUBLIC.CUSTOMER_INFO TO SHARE SHARE_CUST_DATA;

--consumer account: retrieve the consumer account locator if needed
SELECT CURRENT_ACCOUNT();

--provider account: add the consumer account to the share
ALTER SHARE SHARE_CUST_DATA
ADD ACCOUNT = <consumer_account_locator_here>;

--consumer account: list available shares
USE ROLE ACCOUNTADMIN;

SHOW SHARES;

--consumer account: describe the inbound share
DESC SHARE <provider_account_locator_here>.SHARE_CUST_DATA;

--consumer account: create a database from the share
CREATE DATABASE SHR_CUSTOMER
FROM SHARE <provider_account_locator_here>.SHARE_CUST_DATA;

--consumer account: validate the database is attached to the share
DESC SHARE <provider_account_locator_here>.SHARE_CUST_DATA;

--consumer account: query the shared secure view
SELECT *
FROM SHR_CUSTOMER.PUBLIC.CUSTOMER_INFO;
