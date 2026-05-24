--create and set the database
CREATE DATABASE IF NOT EXISTS C4_LD_EX;
USE DATABASE C4_LD_EX;

--create the target table
CREATE OR REPLACE TABLE CUSTOMER
(
  FNAME          STRING,
  LNAME          STRING,
  EMAIL          STRING,
  DATE_OF_BIRTH  DATE,
  CITY           STRING,
  COUNTRY        STRING
);

--create a reusable pipe-delimited file format
CREATE OR REPLACE FILE FORMAT PIPE_DELIM
  TYPE = CSV
  FIELD_DELIMITER = '|'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  DATE_FORMAT = 'YYYY-MM-DD';

--create an internal named stage
CREATE OR REPLACE STAGE CUSTOMER_STAGE
  FILE_FORMAT = PIPE_DELIM;

--upload the local file to the internal stage using Snowflake CLI
--run this command from your operating system command line
--snow stage copy file://customers.csv @CUSTOMER_STAGE;

--verify that the file was uploaded
LIST @CUSTOMER_STAGE;

--load the staged file into the target table
COPY INTO CUSTOMER
FROM @CUSTOMER_STAGE;

--verify the loaded data
SELECT * FROM CUSTOMER;

--remove staged files after loading
REMOVE @CUSTOMER_STAGE;
