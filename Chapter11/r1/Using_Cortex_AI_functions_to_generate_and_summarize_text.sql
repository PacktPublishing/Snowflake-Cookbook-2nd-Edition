USE ROLE SYSADMIN;

CREATE OR REPLACE DATABASE C11_R1;
USE DATABASE C11_R1;
USE SCHEMA PUBLIC;

SELECT AI_COMPLETE(
    'llama3.1-8b',
    'Write a short description of Snowflake as a data platform.'
) AS GENERATED_TEXT;

SELECT SNOWFLAKE.CORTEX.SUMMARIZE(
    'Snowflake is a cloud-based data platform that provides data storage, processing, and analytics solutions. It enables organizations to consolidate data into a single source of truth and supports structured and semi-structured data workloads at scale.'
) AS SUMMARY_TEXT;

CREATE OR REPLACE TABLE CUSTOMER_FEEDBACK (
    FEEDBACK_ID NUMBER,
    COMMENTS STRING
);

INSERT INTO CUSTOMER_FEEDBACK VALUES
(1, 'I really like the product and the overall quality has been excellent, but the delivery arrived three days later than expected and I did not receive a clear update from the shipping team.'),
(2, 'The customer service team responded quickly, answered my questions clearly, and helped resolve my issue without needing multiple follow-up emails.'),
(3, 'The product works as expected, but the packaging was damaged when it arrived and the setup instructions could have been easier to understand.'),
(4, 'I am very satisfied with the purchase because the product was easy to use, arrived on time, and matched the description on the website.');

SELECT 
    FEEDBACK_ID,
    COMMENTS,
    SNOWFLAKE.CORTEX.SUMMARIZE(COMMENTS) AS SUMMARY
FROM CUSTOMER_FEEDBACK;

SELECT 
    FEEDBACK_ID,
    COMMENTS,
    SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-8b',
        CONCAT('Classify the following feedback as Positive, Neutral, or Negative: ', COMMENTS)
    ) AS SENTIMENT
FROM CUSTOMER_FEEDBACK;
