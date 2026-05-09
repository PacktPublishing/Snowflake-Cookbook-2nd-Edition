--create a new database
CREATE DATABASE COOKBOOK;

--set the database context
USE DATABASE COOKBOOK;

--create a table
CREATE OR REPLACE TABLE MY_FIRST_TABLE
(
 ID STRING,
 NAME STRING
);

--query the table
SELECT * FROM MY_FIRST_TABLE;
