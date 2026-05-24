--create the database
CREATE DATABASE JSON_EX;
USE DATABASE JSON_EX;

--create an external stage for the sample JSON file
CREATE OR REPLACE STAGE JSON_STG
URL = 's3://snowflake-cookbook/Chapter03/r5'
FILE_FORMAT = (TYPE = JSON);

--validate access to the stage
LIST @JSON_STG;

--validate that the JSON can be parsed
SELECT PARSE_JSON($1)
FROM @JSON_STG;

--create a staging table for raw JSON
CREATE OR REPLACE TABLE CREDIT_CARD_TEMP
(
    MY_JSON_DATA VARIANT
);

--load JSON into the staging table
COPY INTO CREDIT_CARD_TEMP
FROM @JSON_STG;

--query top-level JSON fields
SELECT
    MY_JSON_DATA:data_set,
    MY_JSON_DATA:extract_date
FROM CREDIT_CARD_TEMP;

--query the credit_cards array as a single value
SELECT MY_JSON_DATA:credit_cards
FROM CREDIT_CARD_TEMP;

--query a single array element using positional notation
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
