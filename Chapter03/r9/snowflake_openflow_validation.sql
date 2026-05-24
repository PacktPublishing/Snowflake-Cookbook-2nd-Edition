--run after the Openflow process group has started

USE DATABASE OPENFLOW_EX;

--confirm the CRM schema was created by Openflow
SHOW SCHEMAS;

--after confirming the CRM schema exists, query the replicated tables
--uncomment these statements after table creation is complete

--SELECT * FROM CRM.CUSTOMERS;
--SELECT * FROM CRM.PRODUCTS;
--SELECT * FROM CRM.ORDERS;
--SELECT * FROM CRM.ORDER_ITEMS;
