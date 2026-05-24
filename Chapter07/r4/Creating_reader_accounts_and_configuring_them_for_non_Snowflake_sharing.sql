--provider account: create a reader account
USE ROLE ACCOUNTADMIN;

CREATE MANAGED ACCOUNT RA_FOR_SUP
    ADMIN_NAME = SP_ACCOUNT_ADMIN
    ADMIN_PASSWORD = 'StrongPassword123!'
    TYPE = READER;

--provider account: verify the reader account
SHOW MANAGED ACCOUNTS;

--reader account: create a sysadmin user
USE ROLE SECURITYADMIN;

CREATE USER SP_SYSADMIN
    PASSWORD = 'StrongPassword123!'
    DEFAULT_ROLE = SYSADMIN
    MUST_CHANGE_PASSWORD = TRUE;

--reader account: grant administrative roles to the new user
GRANT ROLE SYSADMIN TO USER SP_SYSADMIN;
GRANT ROLE SECURITYADMIN TO USER SP_SYSADMIN;

--reader account: create a virtual warehouse
USE ROLE ACCOUNTADMIN;

CREATE WAREHOUSE SP_VW
WITH
    WAREHOUSE_SIZE = 'SMALL'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

--reader account: grant warehouse privileges
GRANT USAGE ON WAREHOUSE SP_VW TO ROLE PUBLIC;
GRANT ALL ON WAREHOUSE SP_VW TO ROLE SYSADMIN;
