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

--create a stream on the staging table
CREATE STREAM CUSTOMER_CHANGES ON TABLE CUSTOMER_STAGING;

--describe the stream
DESC STREAM CUSTOMER_CHANGES;

--insert data into the staging table
INSERT INTO CUSTOMER_STAGING VALUES (1,'Jane Doe','NSW','AU');
INSERT INTO CUSTOMER_STAGING VALUES (2,'Alpha','VIC','AU');

--validate the staging data
SELECT *
FROM CUSTOMER_STAGING;

--query the stream
SELECT *
FROM CUSTOMER_CHANGES;

--create the target customer table
CREATE TABLE CUSTOMER
(
    ID INTEGER,
    NAME STRING,
    STATE STRING,
    COUNTRY STRING
);

--process inserted rows from the stream into the customer table
INSERT INTO CUSTOMER
SELECT
    ID,
    NAME,
    STATE,
    COUNTRY
FROM CUSTOMER_CHANGES
WHERE METADATA$ACTION = 'INSERT';

--validate the target table
SELECT *
FROM CUSTOMER;

--query the stream after processing
SELECT *
FROM CUSTOMER_CHANGES;

--update a row in the staging table
UPDATE CUSTOMER_STAGING
SET NAME = 'John Smith'
WHERE ID = 1;

--query the stream after the update
SELECT *
FROM CUSTOMER_CHANGES;
