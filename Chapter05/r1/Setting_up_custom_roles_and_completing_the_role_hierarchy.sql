--create the DEV database
USE ROLE SYSADMIN;

CREATE DATABASE DEV;

--create the CUSTOMER table in the default PUBLIC schema
USE DATABASE DEV;

CREATE TABLE CUSTOMER
(
    ID STRING,
    NAME STRING
);

--switch to SECURITYADMIN to create users and roles
USE ROLE SECURITYADMIN;

--create a user for testing role privileges
CREATE USER DEV_DBA_USER1
    PASSWORD = 'Password123123'
    MUST_CHANGE_PASSWORD = TRUE;

--test access as DEV_DBA_USER1 after logging in as that user
--this query should fail until privileges are granted
USE DATABASE DEV;

SELECT *
FROM CUSTOMER;

--create a custom role for DEV database administration
USE ROLE SECURITYADMIN;

CREATE ROLE DEV_DBA;

--verify the role has no privileges after creation
SHOW GRANTS TO ROLE DEV_DBA;

--grant privileges to the DEV_DBA role
GRANT ALL ON DATABASE DEV TO ROLE DEV_DBA;
GRANT ALL ON ALL SCHEMAS IN DATABASE DEV TO ROLE DEV_DBA;
GRANT ALL ON TABLE DEV.PUBLIC.CUSTOMER TO ROLE DEV_DBA;

--verify grants to the role
SHOW GRANTS TO ROLE DEV_DBA;

--grant the custom role to the test user
USE ROLE SECURITYADMIN;

GRANT ROLE DEV_DBA TO USER DEV_DBA_USER1;

--test access as DEV_DBA_USER1
USE ROLE DEV_DBA;
USE DATABASE DEV;

SELECT *
FROM CUSTOMER;

--complete the role hierarchy by granting the custom role to SYSADMIN
USE ROLE SECURITYADMIN;

GRANT ROLE DEV_DBA TO ROLE SYSADMIN;
