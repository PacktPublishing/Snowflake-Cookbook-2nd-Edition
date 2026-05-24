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

--create an append-only stream
CREATE STREAM CUSTOMER_CHANGES
ON TABLE CUSTOMER_STAGING
APPEND_ONLY = TRUE;

--describe the stream
DESC STREAM CUSTOMER_CHANGES;

--create the target table
CREATE TABLE CUSTOMER
(
    ID INTEGER,
    NAME STRING,
    STATE STRING,
    COUNTRY STRING
);

--create a task to process new stream rows
USE ROLE SYSADMIN;

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

--grant task execution privileges if needed
USE ROLE ACCOUNTADMIN;

GRANT EXECUTE TASK ON ACCOUNT TO ROLE SYSADMIN;

--schedule and resume the task using the owning role
USE ROLE SYSADMIN;

ALTER TASK PROCESS_NEW_CUSTOMERS
SET SCHEDULE = '5 MINUTE';

ALTER TASK PROCESS_NEW_CUSTOMERS RESUME;

--validate the target table is initially empty
SELECT *
FROM CUSTOMER;

--insert sample rows into the staging table
INSERT INTO CUSTOMER_STAGING VALUES (1, 'Jane Doe', 'NSW', 'AU');
INSERT INTO CUSTOMER_STAGING VALUES (2, 'Alpha', 'VIC', 'AU');

--query the stream
SELECT *
FROM CUSTOMER_CHANGES;

--manually process stream rows into the target table
INSERT INTO CUSTOMER
SELECT
    ID,
    NAME,
    STATE,
    COUNTRY
FROM CUSTOMER_CHANGES
WHERE METADATA$ACTION = 'INSERT';

--validate target data
SELECT *
FROM CUSTOMER;

--insert additional rows for the scheduled task to process
INSERT INTO CUSTOMER_STAGING VALUES (3, 'Mike', 'ACT', 'AU');
INSERT INTO CUSTOMER_STAGING VALUES (4, 'Tango', 'NT', 'AU');

--monitor task execution
SELECT *
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
    TASK_NAME => 'PROCESS_NEW_CUSTOMERS'
))
ORDER BY SCHEDULED_TIME DESC;

--validate additional rows were processed
SELECT *
FROM CUSTOMER;
