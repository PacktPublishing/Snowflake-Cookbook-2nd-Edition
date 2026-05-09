--create and set the database
CREATE OR REPLACE DATABASE C3_R2;
USE DATABASE C3_R2;

--create the target table
CREATE OR REPLACE TABLE CREDIT_CARDS
(
    CUSTOMER_NAME STRING,
    CREDIT_CARD STRING,
    TYPE STRING,
    CCV INTEGER,
    EXP_DATE STRING
);

--create a reusable CSV file format
CREATE OR REPLACE FILE FORMAT GEN_CSV
    TYPE = CSV
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';

--create an external stage for the cloud storage location
CREATE OR REPLACE STAGE C3_R2_STAGE
    URL = 's3://cookbook-raw/chapter03/r2/'
    STORAGE_INTEGRATION = S3_INTEGRATION
    FILE_FORMAT = GEN_CSV;

--list files in the stage
LIST @C3_R2_STAGE;

--load the staged files into the target table
COPY INTO CREDIT_CARDS
FROM @C3_R2_STAGE;

--verify the number of rows loaded
USE C3_R2;
SELECT COUNT(*) FROM CREDIT_CARDS;
