--create a new user with no default custom role
USE ROLE SECURITYADMIN;

CREATE USER MARKETING_USER1
    PASSWORD = 'Password123123'
    MUST_CHANGE_PASSWORD = TRUE;

--validate current role after logging in as MARKETING_USER1
SELECT CURRENT_ROLE();

--create and grant the marketing role
USE ROLE SECURITYADMIN;

CREATE ROLE MKT_USER;

GRANT ROLE MKT_USER TO USER MARKETING_USER1;

--set the granted role as the default role
USE ROLE SECURITYADMIN;

ALTER USER MARKETING_USER1
SET DEFAULT_ROLE = MKT_USER;

--validate current role after logging in again as MARKETING_USER1
SELECT CURRENT_ROLE();
