--create a database for the JSON example
CREATE DATABASE JSON_EX;

--create an external stage for the JSON file
CREATE OR REPLACE STAGE JSON_STG
    URL = 's3://snowflake-cookbook/Chapter03/r5'
    FILE_FORMAT = (TYPE = JSON);

--list files in the stage
LIST @JSON_STG;

--parse and validate the JSON data
SELECT PARSE_JSON($1)
FROM @JSON_STG;

--create a staging table for the raw JSON document
CREATE OR REPLACE TABLE CREDIT_CARD_TEMP
(
    MY_JSON_DATA VARIANT
);

--load the JSON document into the staging table
COPY INTO CREDIT_CARD_TEMP
FROM @JSON_STG;

--query top-level fields from the JSON document
SELECT
    MY_JSON_DATA:data_set,
    MY_JSON_DATA:extract_date
FROM CREDIT_CARD_TEMP;

--query the full credit_cards array
SELECT MY_JSON_DATA:credit_cards
FROM CREDIT_CARD_TEMP;

--access a single array element using positional notation
SELECT
    MY_JSON_DATA:credit_cards[0].CreditCardNo,
    MY_JSON_DATA:credit_cards[0].CreditCardHolder
FROM CREDIT_CARD_TEMP;

--flatten the credit_cards array into relational rows
SELECT
    MY_JSON_DATA:extract_date,
    VALUE:CreditCardNo::STRING,
    VALUE:CreditCardHolder::STRING,
    VALUE:CardPin::INTEGER,
    VALUE:CardCVV::STRING,
    VALUE:CardExpiry::STRING
FROM CREDIT_CARD_TEMP,
    LATERAL FLATTEN(INPUT => MY_JSON_DATA:credit_cards);
