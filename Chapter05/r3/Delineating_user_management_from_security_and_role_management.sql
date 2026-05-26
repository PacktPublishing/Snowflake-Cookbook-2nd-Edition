--create a database for privilege testing
USE ROLE SYSADMIN;

CREATE DATABASE TEST_DATABASE;

--create a user operations user
USE ROLE SECURITYADMIN;

CREATE USER USER_OPERATIONS1
    PASSWORD = 'Password123123'
    MUST_CHANGE_PASSWORD = TRUE;

--grant USERADMIN to the user and set it as the default role
USE ROLE SECURITYADMIN;

GRANT ROLE USERADMIN TO USER USER_OPERATIONS1;

ALTER USER USER_OPERATIONS1
SET DEFAULT_ROLE = USERADMIN;

--validate the default role after logging in as USER_OPERATIONS1
SELECT CURRENT_ROLE();

--create a new user as USER_OPERATIONS1
CREATE USER NEW_ANALYST1
    PASSWORD = 'Password123123'
    MUST_CHANGE_PASSWORD = TRUE;

--create a new role as USER_OPERATIONS1
CREATE ROLE BA_ROLE;

--grant the role to the new analyst user
GRANT ROLE BA_ROLE TO USER NEW_ANALYST1;

--set BA_ROLE as the default role for the new analyst user
ALTER USER NEW_ANALYST1
SET DEFAULT_ROLE = BA_ROLE;

--attempt to grant object privileges as USERADMIN
--this should fail because USERADMIN cannot grant object privileges
GRANT USAGE ON DATABASE TEST_DATABASE TO ROLE BA_ROLE;

--grant the same object privilege as SECURITYADMIN
USE ROLE SECURITYADMIN;

GRANT USAGE ON DATABASE TEST_DATABASE TO ROLE BA_ROLE;
