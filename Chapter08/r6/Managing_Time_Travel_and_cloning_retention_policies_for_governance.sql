--set role and create a database for retention policy testing
USE ROLE SYSADMIN;

CREATE OR REPLACE DATABASE C8_R6;
USE DATABASE C8_R6;
USE SCHEMA PUBLIC;

--create a customer table from Snowflake sample data
CREATE OR REPLACE TABLE CUSTOMER AS
SELECT *
FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.CUSTOMER
LIMIT 100000;

--review current retention settings
SHOW DATABASES LIKE 'C8_R6';
SHOW SCHEMAS LIKE 'PUBLIC';
SHOW TABLES LIKE 'CUSTOMER';

--set retention at the database level
ALTER DATABASE C8_R6
SET DATA_RETENTION_TIME_IN_DAYS = 3;

--override retention at the table level
ALTER TABLE CUSTOMER
SET DATA_RETENTION_TIME_IN_DAYS = 5;

--validate the updated table retention setting
SHOW TABLES LIKE 'CUSTOMER';

--create a clone of the table
CREATE OR REPLACE TABLE CUSTOMER_CLONE
CLONE CUSTOMER;

--review retention settings for the cloned table
SHOW TABLES LIKE 'CUSTOMER_CLONE';

--modify retention on the cloned table
ALTER TABLE CUSTOMER_CLONE
SET DATA_RETENTION_TIME_IN_DAYS = 1;

--validate the updated cloned table retention setting
SHOW TABLES LIKE 'CUSTOMER_CLONE';
