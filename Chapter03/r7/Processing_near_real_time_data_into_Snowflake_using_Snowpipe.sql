--create and set the database
CREATE OR REPLACE DATABASE SP_EX;
USE SP_EX;

--create the target table for Snowpipe ingestion
CREATE OR REPLACE TABLE TRANSACTIONS
(
  TRANSACTION_DATE DATE,
  CUSTOMER_ID NUMBER,
  TRANSACTION_ID NUMBER,
  AMOUNT NUMBER
);

--create an external stage pointing to the S3 bucket used for Snowpipe
--replace <bucket> with your actual bucket name
CREATE OR REPLACE STAGE SP_TRX_STAGE 
URL = 's3://<bucket>'
STORAGE_INTEGRATION = S3_INTEGRATION;

--validate stage access
LIST @SP_TRX_STAGE;

--create a Snowpipe with auto-ingest enabled
CREATE OR REPLACE PIPE TX_LD_PIPE
AUTO_INGEST = TRUE
AS
COPY INTO TRANSACTIONS
FROM @SP_TRX_STAGE
FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1);

--retrieve the notification channel ARN
SHOW PIPES LIKE '%TX_LD_PIPE%';

--after configuring cloud event notifications and uploading files, verify loaded rows
SELECT COUNT(*) FROM TRANSACTIONS;
