--create and set the database
CREATE OR REPLACE DATABASE C4_LD_EX;
USE DATABASE C4_LD_EX;

--create the target table
CREATE OR REPLACE TABLE CUSTOMER
(
    FNAME STRING,
    LNAME STRING,
    EMAIL STRING,
    DATE_OF_BIRTH DATE,
    CITY STRING,
    COUNTRY STRING
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

--set the context before uploading the file
USE DATABASE C4_LD_EX;
USE SCHEMA PUBLIC;

--upload the local file to the internal stage
PUT file://customers.csv @CUSTOMER_STAGE;

--list files in the internal stage
LIST @CUSTOMER_STAGE;

--load the file into the target table
COPY INTO CUSTOMER
FROM @CUSTOMER_STAGE;

--verify the loaded data
USE C4_LD_EX;
SELECT * FROM CUSTOMER;

--remove staged files after loading
REMOVE @CUSTOMER_STAGE;
