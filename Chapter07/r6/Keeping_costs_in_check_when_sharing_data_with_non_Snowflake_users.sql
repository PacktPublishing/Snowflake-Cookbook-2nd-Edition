--reader account: create a resource monitor
USE ROLE ACCOUNTADMIN;

CREATE RESOURCE MONITOR RM_READER_ACCOUNT
WITH
    CREDIT_QUOTA = 100
    FREQUENCY = MONTHLY
    START_TIMESTAMP = IMMEDIATELY
    TRIGGERS
        ON 80 PERCENT DO NOTIFY
        ON 100 PERCENT DO SUSPEND;

--reader account: attach the resource monitor to the reader account warehouse
ALTER WAREHOUSE SP_VW
SET RESOURCE_MONITOR = RM_READER_ACCOUNT;

--reader account: verify the resource monitor
SHOW RESOURCE MONITORS;

--reader account: verify the warehouse resource monitor assignment
SHOW WAREHOUSES LIKE 'SP_VW';
