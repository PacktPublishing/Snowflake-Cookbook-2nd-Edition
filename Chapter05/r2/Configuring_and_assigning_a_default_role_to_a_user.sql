--create a new user with no default role
USE ROLE SECURITYADMIN;

CREATE USER MARKETING_USER1
    PASSWORD = 'Password123123'
    MUST_CHANGE_PASSWORD = TRUE;

--validate the current role after logging in as MARKETING_USER1
SELECT CURRENT_ROLE();

--create and grant a marketing role
USE ROLE SECURITYADMIN;

CREATE ROLE MKT_USER;

GRANT ROLE MKT_USER TO USER MARKETING_USER1;

--set the marketing role as the default role for the user
USE ROLE SECURITYADMIN;

ALTER USER MARKETING_USER1
SET DEFAULT_ROLE = MKT_USER;

--validate the current role after logging in as MARKETING_USER1
SELECT CURRENT_ROLE();
