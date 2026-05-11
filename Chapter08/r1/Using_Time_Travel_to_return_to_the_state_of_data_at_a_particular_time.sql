--create a database and customer table from Snowflake sample data
CREATE DATABASE C8_R1;

CREATE TABLE CUSTOMER AS
SELECT *
FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.CUSTOMER
LIMIT 100000;

--validate the customer table data
SELECT *
FROM CUSTOMER
LIMIT 100;

--capture the current timestamp before making changes
SELECT CURRENT_TIMESTAMP;

--update the email address for all rows
UPDATE CUSTOMER
SET C_EMAIL_ADDRESS = 'john.doe@gmail.com';

--validate the updated email values
SELECT DISTINCT C_EMAIL_ADDRESS
FROM CUSTOMER;

--query the table as it existed at a specific timestamp
SELECT DISTINCT C_EMAIL_ADDRESS
FROM CUSTOMER AT
(
    TIMESTAMP => '2026-03-23 16:03:42.696 -0700'::TIMESTAMP_LTZ
);

--query all rows from the table at a specific timestamp
SELECT *
FROM CUSTOMER AT
(
    TIMESTAMP => '2026-03-23 16:03:42.696 -0700'::TIMESTAMP_TZ
);

--query all rows from the table before a specific timestamp
SELECT *
FROM CUSTOMER BEFORE
(
    TIMESTAMP => '2026-03-23 16:03:42.696 -0700'::TIMESTAMP_TZ
);
