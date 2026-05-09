--switch to the SYSADMIN role
USE ROLE SYSADMIN;

--verify the current role
SELECT CURRENT_ROLE();

--create a multi-cluster virtual warehouse
CREATE WAREHOUSE ELT_WH
WAREHOUSE_SIZE = XSMALL
MAX_CLUSTER_COUNT = 3
MIN_CLUSTER_COUNT = 1
SCALING_POLICY = ECONOMY
AUTO_SUSPEND = 300
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE
COMMENT = 'Virtual warehouse for ETL workloads. Auto scales between 1 and 3 clusters depending on the workload';

--verify the warehouse was created
SHOW WAREHOUSES LIKE 'ELT_WH';
