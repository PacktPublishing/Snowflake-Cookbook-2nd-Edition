--create a development DBA user
USE ROLE SECURITYADMIN;

CREATE USER DEV_DBA_1
    PASSWORD = 'Password123123'
    DEFAULT_ROLE = DEV_DBA_ROLE
    MUST_CHANGE_PASSWORD = TRUE;

--create and grant the development DBA role
CREATE ROLE DEV_DBA_ROLE;

GRANT ROLE DEV_DBA_ROLE TO USER DEV_DBA_1;

--create the development database
USE ROLE SYSADMIN;

CREATE DATABASE DEV_DB;

--grant full access on the development database to the development DBA role
GRANT ALL ON DATABASE DEV_DB TO ROLE DEV_DBA_ROLE;

--create a production DBA user
USE ROLE SECURITYADMIN;

CREATE USER PROD_DBA_1
    PASSWORD = 'Password123123'
    DEFAULT_ROLE = PROD_DBA_ROLE
    MUST_CHANGE_PASSWORD = TRUE;

--create and grant the production DBA role
CREATE ROLE PROD_DBA_ROLE;

GRANT ROLE PROD_DBA_ROLE TO USER PROD_DBA_1;

--create the production database
USE ROLE SYSADMIN;

CREATE DATABASE PROD_DB;

--grant full access on the production database to the production DBA role
GRANT ALL ON DATABASE PROD_DB TO ROLE PROD_DBA_ROLE;
