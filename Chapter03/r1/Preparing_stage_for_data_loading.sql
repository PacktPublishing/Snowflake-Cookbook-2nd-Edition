--create a storage integration for secure access to an S3 bucket
CREATE STORAGE INTEGRATION S3_INTEGRATION
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = '<arn:aws:iam::123456789123:role/Role_For_Snowflake>'
    STORAGE_ALLOWED_LOCATIONS = ('s3://<bucket>');

--describe the storage integration and note the IAM user ARN and external ID
DESC INTEGRATION S3_INTEGRATION;

--grant the storage integration to SYSADMIN
GRANT USAGE ON INTEGRATION S3_INTEGRATION TO ROLE SYSADMIN;

--switch to SYSADMIN
USE ROLE SYSADMIN;

--create an external stage using the storage integration
CREATE STAGE S3_RESTRICTED_STAGE
    STORAGE_INTEGRATION = S3_INTEGRATION
    URL = 's3://<bucket>';

--list files in the external stage to verify access
LIST @S3_RESTRICTED_STAGE;
