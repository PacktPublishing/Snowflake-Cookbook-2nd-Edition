--create a dedicated database and schema for Git-related objects
CREATE OR REPLACE DATABASE DATAOPS;
CREATE OR REPLACE SCHEMA DATAOPS.GIT;

--set the database and schema context
USE DATABASE DATAOPS;
USE SCHEMA GIT;

--create a secret for Git authentication
CREATE OR REPLACE SECRET GIT_CREDENTIAL_SECRET
TYPE = PASSWORD
USERNAME = '<GIT_USERNAME>'
PASSWORD = '<PERSONAL_ACCESS_TOKEN>';

--create an API integration for Git over HTTPS
CREATE OR REPLACE API INTEGRATION GIT_API_INTEGRATION
API_PROVIDER = GIT_HTTPS_API
API_ALLOWED_PREFIXES = ('https://github.com/<ORG_OR_USER>/')
ALLOWED_AUTHENTICATION_SECRETS = (GIT_CREDENTIAL_SECRET)
ENABLED = TRUE;

--create a Git repository object in Snowflake
CREATE OR REPLACE GIT REPOSITORY COOKBOOK_REPO
API_INTEGRATION = GIT_API_INTEGRATION
ORIGIN = 'https://github.com/<ORG_OR_USER>/<REPO_NAME>.git';

--fetch the latest repository contents
ALTER GIT REPOSITORY COOKBOOK_REPO FETCH;

--show branches available in the Git repository clone
SHOW GIT BRANCHES IN GIT REPOSITORY COOKBOOK_REPO;

--list files in a branch
LS @COOKBOOK_REPO/branches/<BRANCH_NAME>/;

--execute a SQL file directly from the Git repository clone
EXECUTE IMMEDIATE FROM @COOKBOOK_REPO/branches/<BRANCH_NAME>/CUSTOMER.sql;
