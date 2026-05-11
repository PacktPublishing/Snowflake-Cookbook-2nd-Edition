--create a database and staging table
CREATE DATABASE STREAM_DEMO;
USE DATABASE STREAM_DEMO;

CREATE TABLE CUSTOMER_STAGING
(
    ID INTEGER,
    NAME STRING,
    STATE STRING,
    COUNTRY STRING
);

--create an append-only stream on the staging table
CREATE STREAM CUSTOMER_CHANGES
ON TABLE CUSTOMER_STAGING
APPEND_ONLY = TRUE;

--describe the stream
DESC STREAM CUSTOMER_CHANGES;

--create the target customer table
CREATE TABLE CUSTOMER
(
    ID INTEGER,
    NAME STRING,
    STATE STRING,
    COUNTRY STRING
);

--create a task to process new stream rows
CREATE TASK PROCESS_NEW_CUSTOMERS
    WAREHOUSE = COMPUTE_WH
    COMMENT = 'Process new data into customer'
AS
    INSERT INTO CUSTOMER
    SELECT
        ID,
        NAME,
        STATE,
        COUNTRY
    FROM CUSTOMER_CHANGES
    WHERE METADATA$ACTION = 'INSERT';

--schedule and resume the task
ALTER TASK PROCESS_NEW_CUSTOMERS
SET SCHEDULE = '5 MINUTE';

ALTER TASK PROCESS_NEW_CUSTOMERS RESUME;

--confirm the customer table is empty
SELECT *
FROM CUSTOMER;

--insert sample rows into the staging table
INSERT INTO CUSTOMER_STAGING VALUES (1,'Jane Doe','NSW','AU');
INSERT INTO CUSTOMER_STAGING VALUES (2,'Alpha','VIC','AU');

--query the stream
SELECT *
FROM CUSTOMER_CHANGES;

--manually process stream rows into the customer table
INSERT INTO CUSTOMER
SELECT
    ID,
    NAME,
    STATE,
    COUNTRY
FROM CUSTOMER_CHANGES
WHERE METADATA$ACTION = 'INSERT';

--validate the customer table
SELECT *
FROM CUSTOMER;

--insert additional rows into the staging table
INSERT INTO CUSTOMER_STAGING VALUES (3,'Mike','ACT','AU');
INSERT INTO CUSTOMER_STAGING VALUES (4,'Tango','NT','AU');

--monitor task execution
SELECT *
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
    TASK_NAME => 'PROCESS_NEW_CUSTOMERS'
))
ORDER BY SCHEDULED_TIME DESC;

--validate the additional rows were processed
SELECT *
FROM CUSTOMER;
