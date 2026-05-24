--create and set the database
CREATE OR REPLACE DATABASE C3_R2;
USE DATABASE C3_R2;

--create the target table
CREATE OR REPLACE TABLE CREDIT_CARDS
(
  CUSTOMER_NAME STRING,
  CREDIT_CARD   STRING,
  TYPE          STRING,
  CCV           STRING,
  EXP_DATE      STRING
);

--create a reusable CSV file format
CREATE OR REPLACE FILE FORMAT GEN_CSV
TYPE = CSV
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

--option 1: create a stage for the public sample data
CREATE OR REPLACE STAGE C3_R2_STAGE
 URL = 's3://cookbook-raw/chapter03/r2/'
 FILE_FORMAT = GEN_CSV;

--option 2: create a stage for your own private bucket using a storage integration
--replace placeholder values before running
/*
CREATE OR REPLACE STAGE C3_R2_STAGE
  URL = 's3://<BUCKET_NAME>/<PATH>/'
  STORAGE_INTEGRATION = <STORAGE_INTEGRATION_NAME>
  FILE_FORMAT = GEN_CSV;
*/

--validate access to the stage
LIST @C3_R2_STAGE;

--load data from the stage into the target table
COPY INTO CREDIT_CARDS
FROM @C3_R2_STAGE;

--verify row count
SELECT COUNT(*) FROM CREDIT_CARDS;
