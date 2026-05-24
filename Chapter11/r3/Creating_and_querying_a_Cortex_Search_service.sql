USE ROLE SYSADMIN;

CREATE OR REPLACE DATABASE C11_R3;

CREATE OR REPLACE SCHEMA C11_R3.PUBLIC;

CREATE OR REPLACE WAREHOUSE CORTEX_SEARCH_WH
WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE;

USE DATABASE C11_R3;
USE SCHEMA PUBLIC;

CREATE OR REPLACE TABLE SUPPORT_TRANSCRIPTS (
    TRANSCRIPT_ID NUMBER,
    TRANSCRIPT_TEXT STRING,
    REGION STRING,
    AGENT_ID STRING
);

INSERT INTO SUPPORT_TRANSCRIPTS VALUES
(1, 'My internet has been down since yesterday and I need help restoring the service.', 'North America', 'AG1001'),
(2, 'I was overcharged on my last bill and need someone to explain the additional fees.', 'Europe', 'AG1002'),
(3, 'I cannot reset my password because the email link is not working.', 'Asia', 'AG1003'),
(4, 'The router I received appears to be faulty and I would like to request a replacement.', 'North America', 'AG1004'),
(5, 'The mobile app keeps crashing whenever I try to view my account balance.', 'Europe', 'AG1005');

CREATE OR REPLACE CORTEX SEARCH SERVICE TRANSCRIPT_SEARCH_SERVICE
  ON TRANSCRIPT_TEXT
  ATTRIBUTES REGION, AGENT_ID
  WAREHOUSE = CORTEX_SEARCH_WH
  TARGET_LAG = '1 day'
  EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
  AS (
    SELECT
        TRANSCRIPT_TEXT,
        REGION,
        AGENT_ID
    FROM SUPPORT_TRANSCRIPTS
  );

SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'C11_R3.PUBLIC.TRANSCRIPT_SEARCH_SERVICE',
    '{
      "query": "internet issues",
      "columns": [
        "TRANSCRIPT_TEXT",
        "REGION",
        "AGENT_ID"
      ],
      "limit": 3
    }'
  )
)['results'] AS RESULTS;

SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'C11_R3.PUBLIC.TRANSCRIPT_SEARCH_SERVICE',
    '{
      "query": "service problem",
      "columns": [
        "TRANSCRIPT_TEXT",
        "REGION",
        "AGENT_ID"
      ],
      "filter": {
        "@eq": {
          "REGION": "North America"
        }
      },
      "limit": 3
    }'
  )
)['results'] AS RESULTS;

SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'C11_R3.PUBLIC.TRANSCRIPT_SEARCH_SERVICE',
    '{
      "query": "billing problem",
      "columns": [
        "TRANSCRIPT_TEXT",
        "REGION",
        "AGENT_ID"
      ],
      "limit": 3
    }'
  )
)['results'] AS RESULTS;
