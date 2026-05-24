--return the current date
SELECT CURRENT_DATE();

--derive a weekend processing flag from the current date
SELECT IFF(
    DAYNAME(CURRENT_DATE()) IN ('Sat', 'Sun'),
    TRUE,
    FALSE
) AS WEEK_END_PROCESSING_FLAG;

--return the current timestamp
SELECT CURRENT_TIMESTAMP();

--return the current client
SELECT CURRENT_CLIENT();

--return the current Snowflake region
SELECT CURRENT_REGION();

--return the current role
SELECT CURRENT_ROLE();

--return the current user
SELECT CURRENT_USER();

--return the current database
USE DATABASE SNOWFLAKE_SAMPLE_DATA;

SELECT CURRENT_DATABASE();

--return the current schema
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA INFORMATION_SCHEMA;

SELECT CURRENT_SCHEMA();

--return the current warehouse
SELECT CURRENT_WAREHOUSE();
