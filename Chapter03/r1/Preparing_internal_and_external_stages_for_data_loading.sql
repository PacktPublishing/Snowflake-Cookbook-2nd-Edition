--Snowflake setup for preparing external stages for data loading

--create the storage integration
--replace the IAM role ARN and bucket value with your environment-specific values
CREATE STORAGE INTEGRATION S3_INTEGRATION
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN =
'<arn:aws:iam::123456789123:role/Role_For_Snowflake>'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<bucket>');

--describe the storage integration
--record STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID
DESC INTEGRATION S3_INTEGRATION;

--grant usage on the integration to SYSADMIN
--run this as the role that created the storage integration
GRANT USAGE ON INTEGRATION S3_INTEGRATION TO ROLE SYSADMIN;

--create a database and schema for the external stage
USE ROLE SYSADMIN;

CREATE DATABASE IF NOT EXISTS STAGE_EX;
USE DATABASE STAGE_EX;

CREATE SCHEMA IF NOT EXISTS EXTERNAL_STAGE;
USE SCHEMA EXTERNAL_STAGE;

--create an external stage using the storage integration
CREATE STAGE S3_RESTRICTED_STAGE
  STORAGE_INTEGRATION = S3_INTEGRATION
  URL = 's3://<BUCKET_NAME>';

--validate stage access
LIST @S3_RESTRICTED_STAGE;
