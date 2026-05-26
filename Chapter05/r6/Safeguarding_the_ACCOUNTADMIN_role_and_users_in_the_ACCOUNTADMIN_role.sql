--create a secondary account administrator user
USE ROLE SECURITYADMIN;

CREATE USER SECOND_ACCOUNT_ADMIN
    PASSWORD = 'Password123123'
    EMAIL = 'john@doe.com'
    MUST_CHANGE_PASSWORD = TRUE;

--grant ACCOUNTADMIN to the secondary administrator
GRANT ROLE ACCOUNTADMIN TO USER SECOND_ACCOUNT_ADMIN;

--set SECURITYADMIN as the default role to avoid accidental ACCOUNTADMIN usage
ALTER USER SECOND_ACCOUNT_ADMIN
SET DEFAULT_ROLE = SECURITYADMIN;

--verify grants and user settings
SHOW GRANTS TO USER SECOND_ACCOUNT_ADMIN;

DESC USER SECOND_ACCOUNT_ADMIN;

--initiate MFA enrollment for the secondary administrator
ALTER USER SECOND_ACCOUNT_ADMIN ENROLL MFA;
