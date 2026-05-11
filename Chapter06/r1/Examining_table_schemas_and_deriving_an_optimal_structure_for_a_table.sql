--create the database, schema, and initial table
CREATE DATABASE C6_R1;
CREATE SCHEMA RECIPES;

USE DATABASE C6_R1;
USE SCHEMA RECIPES;

CREATE TABLE CUSTOMER
(
    CUSTOMERID VARCHAR(100),
    FNAME VARCHAR(1024),
    LNAME VARCHAR(1024),
    EMAIL VARCHAR(1024),
    DATE_OF_BIRTH VARCHAR(1024),
    CITY VARCHAR(1024),
    COUNTRY VARCHAR(1024)
);

--create a reusable CSV file format
CREATE FILE FORMAT CSV_FORMAT
    TYPE = CSV
    FIELD_DELIMITER = ','
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
    DATE_FORMAT = 'YYYY-MM-DD';

--create an external stage for the sample customer file
CREATE OR REPLACE STAGE C6_R1_STAGE
    URL = 's3://snowflake-cookbook/Chapter06/r1'
    FILE_FORMAT = CSV_FORMAT;

--list files in the stage
LIST @C6_R1_STAGE;

--load data into the initial table
COPY INTO CUSTOMER
FROM @C6_R1_STAGE;

--review table storage
SHOW TABLES;

--create an optimized version of the customer table
CREATE TABLE CUSTOMER_OPT
(
    CUSTOMERID DECIMAL(10,0),
    FNAME VARCHAR(50),
    LNAME VARCHAR(50),
    EMAIL VARCHAR(50),
    DATE_OF_BIRTH DATE,
    CITY VARCHAR(50),
    COUNTRY VARCHAR(50)
);

--load the same data into the optimized table
COPY INTO CUSTOMER_OPT
FROM @C6_R1_STAGE;

--compare table storage
SHOW TABLES;
