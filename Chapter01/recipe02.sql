--switch to the SYSADMIN role to create and manage the virtual warehouse.
USE ROLE SYSADMIN;

--verify that the SYSADMIN role is active.
SELECT CURRENT_ROLE();

--create a multi-cluster virtual warehouse that can auto-scale between one and three clusters.
CREATE WAREHOUSE ELT_WH
    WAREHOUSE_SIZE = XSMALL
    MAX_CLUSTER_COUNT = 3
    MIN_CLUSTER_COUNT = 1
    SCALING_POLICY = ECONOMY
    AUTO_SUSPEND = 300 -- suspend after 5 minutes (300 seconds) of inactivity
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Virtual warehouse for ETL workloads. Auto scales between 1 and 3 clusters depending on the workload';

--verify that the warehouse was created successfully.
SHOW WAREHOUSES LIKE 'ELT_WH';
