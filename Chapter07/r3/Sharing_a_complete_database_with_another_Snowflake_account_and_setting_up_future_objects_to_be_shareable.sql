--provider account: create a database and sample customer table
USE ROLE ACCOUNTADMIN;

CREATE DATABASE C7_R3;

CREATE TABLE CUSTOMER
(
    CUST_ID NUMBER,
    CUST_NAME STRING
);

--provider account: create the share
CREATE SHARE SHARE_CUST_DATABASE;

--grant usage to the share
GRANT USAGE ON DATABASE C7_R3 TO SHARE SHARE_CUST_DATABASE;
GRANT USAGE ON SCHEMA C7_R3.PUBLIC TO SHARE SHARE_CUST_DATABASE;

--grant select on all existing tables in the schema
GRANT SELECT ON ALL TABLES IN SCHEMA C7_R3.PUBLIC TO SHARE SHARE_CUST_DATABASE;

--consumer account: retrieve the account locator if needed
SELECT CURRENT_ACCOUNT();

--provider account: add the consumer account to the share
ALTER SHARE SHARE_CUST_DATABASE
ADD ACCOUNT = <consumer_account_locator_here>;

--provider account: describe the share
DESC SHARE SHARE_CUST_DATABASE;

--provider account: create a new table in the shared database
USE C7_R3;

CREATE TABLE CUSTOMER_ADDRESS
(
    CUST_ID NUMBER,
    CUST_ADDRESS STRING
);

--provider account: check whether the new table was added to the share
DESC SHARE SHARE_CUST_DATABASE;

--provider account: grant select on all current tables again to include newly created tables
GRANT SELECT ON ALL TABLES IN SCHEMA C7_R3.PUBLIC TO SHARE SHARE_CUST_DATABASE;

--provider account: validate that both tables are now included in the share
DESC SHARE SHARE_CUST_DATABASE;
