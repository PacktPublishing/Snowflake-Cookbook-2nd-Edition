--create and set the database
CREATE OR REPLACE DATABASE SP_EX;
USE SP_EX;

--create the target table
CREATE OR REPLACE TABLE TRANSACTIONS
(
    TRANSACTION_DATE DATE,
    CUSTOMER_ID NUMBER,
    TRANSACTION_ID NUMBER,
    AMOUNT NUMBER
);

--create an external stage for files delivered to S3
CREATE OR REPLACE STAGE SP_TRX_STAGE
    URL = 's3://<bucket>'
    STORAGE_INTEGRATION = S3_INTEGRATION;

--verify access to the stage
LIST @SP_TRX_STAGE;

--create a Snowpipe for automatic ingestion
CREATE OR REPLACE PIPE TX_LD_PIPE
    AUTO_INGEST = TRUE
AS
COPY INTO TRANSACTIONS
FROM @SP_TRX_STAGE
FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1);

--retrieve the notification channel value for AWS event configuration
SHOW PIPES LIKE '%TX_LD_PIPE%';

--verify rows loaded by Snowpipe
SELECT COUNT(*) FROM TRANSACTIONS;
