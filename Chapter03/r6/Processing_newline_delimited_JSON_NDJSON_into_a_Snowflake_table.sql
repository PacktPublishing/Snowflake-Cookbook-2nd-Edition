--create the database
CREATE DATABASE NDJSON_EX;
USE DATABASE NDJSON_EX;

--create an external stage for the sample NDJSON file
CREATE OR REPLACE STAGE NDJSON_STG
URL = 's3://snowflake-cookbook/Chapter03/r6'
FILE_FORMAT = (TYPE = JSON, STRIP_OUTER_ARRAY = TRUE);

--validate access to the stage
LIST @NDJSON_STG;

--validate that each NDJSON record can be parsed
SELECT PARSE_JSON($1)
FROM @NDJSON_STG;

--preview parsed relational columns
SELECT
    PARSE_JSON($1):CreditCardNo::STRING     AS CreditCardNo,
    PARSE_JSON($1):CreditCardHolder::STRING AS CreditCardHolder,
    PARSE_JSON($1):CardPin::INTEGER         AS CardPin,
    PARSE_JSON($1):CardExpiry::STRING       AS CardExpiry,
    PARSE_JSON($1):CardCVV::STRING          AS CardCVV
FROM @NDJSON_STG;

--create a relational table from parsed NDJSON records
CREATE OR REPLACE TABLE CREDIT_CARD_DATA AS
SELECT
    PARSE_JSON($1):CreditCardNo::STRING     AS CreditCardNo,
    PARSE_JSON($1):CreditCardHolder::STRING AS CreditCardHolder,
    PARSE_JSON($1):CardPin::INTEGER         AS CardPin,
    PARSE_JSON($1):CardExpiry::STRING       AS CardExpiry,
    PARSE_JSON($1):CardCVV::STRING          AS CardCVV
FROM @NDJSON_STG;

--verify loaded data
SELECT * FROM CREDIT_CARD_DATA;
