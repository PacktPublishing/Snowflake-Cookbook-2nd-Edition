--run this script in Snowflake after the Openflow process group has started

--set the target database context
USE DATABASE OPENFLOW_EX;

--show schemas created in the target database
SHOW SCHEMAS;

--query replicated CRM tables after Openflow creates them
--uncomment these statements after confirming the CRM schema exists

--SELECT * FROM CRM.CUSTOMERS;
--SELECT * FROM CRM.PRODUCTS;
--SELECT * FROM CRM.ORDERS;
--SELECT * FROM CRM.ORDER_ITEMS;
