--create a database for the NDJSON example
CREATE DATABASE NDJSON_EX;

--create an external stage for the NDJSON file
CREATE OR REPLACE STAGE NDJSON_STG
    URL = 's3://snowflake-cookbook/Chapter03/r6'
    FILE_FORMAT = (TYPE = JSON, STRIP_OUTER_ARRAY = TRUE);

--list files in the stage
LIST @NDJSON_STG;

--parse and validate the NDJSON data
SELECT PARSE_JSON($1)
FROM @NDJSON_STG;

--convert each JSON record into relational columns
SELECT
    PARSE_JSON($1):CreditCardNo::STRING AS CreditCardNo,
    PARSE_JSON($1):CreditCardHolder::STRING AS CreditCardHolder,
    PARSE_JSON($1):CardPin::INTEGER AS CardPin,
    PARSE_JSON($1):CardExpiry::STRING AS CardExpiry,
    PARSE_JSON($1):CardCVV::STRING AS CardCVV
FROM @NDJSON_STG;

--create a relational table from the parsed NDJSON data
CREATE OR REPLACE TABLE CREDIT_CARD_DATA AS
SELECT
    PARSE_JSON($1):CreditCardNo::STRING AS CreditCardNo,
    PARSE_JSON($1):CreditCardHolder::STRING AS CreditCardHolder,
    PARSE_JSON($1):CardPin::INTEGER AS CardPin,
    PARSE_JSON($1):CardExpiry::STRING AS CardExpiry,
    PARSE_JSON($1):CardCVV::STRING AS CardCVV
FROM @NDJSON_STG;

--verify the loaded data
SELECT * FROM CREDIT_CARD_DATA;
