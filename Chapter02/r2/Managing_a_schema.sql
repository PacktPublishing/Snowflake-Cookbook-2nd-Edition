--create a database for testing schema creation
CREATE DATABASE TESTING_SCHEMA_CREATION;

--show the schemas automatically created with the database
SHOW SCHEMAS IN DATABASE TESTING_SCHEMA_CREATION;

--set the database context
USE DATABASE TESTING_SCHEMA_CREATION;

--create a custom schema
CREATE SCHEMA A_CUSTOM_SCHEMA
COMMENT = 'Custom schema example';

--verify the schema was created
SHOW SCHEMAS LIKE 'A_CUSTOM_SCHEMA' IN DATABASE TESTING_SCHEMA_CREATION;

--create a transient schema for temporary ELT data
CREATE TRANSIENT SCHEMA TEMPORARY_DATA
DATA_RETENTION_TIME_IN_DAYS = 0
COMMENT = 'Schema containing temporary data used by ELT processes';

--verify the transient schema settings
SHOW SCHEMAS LIKE 'TEMPORARY_DATA' IN DATABASE TESTING_SCHEMA_CREATION;
