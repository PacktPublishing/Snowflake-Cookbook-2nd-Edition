--create a database for JavaScript table UDFs
CREATE DATABASE C10_R4;
USE DATABASE C10_R4;
USE SCHEMA PUBLIC;

--call the built-in GENERATOR table function
SELECT
    SEQ4() AS INCREMENTAL_ID,
    RANDOM() AS A_RANDOM_NUMBER
FROM TABLE(GENERATOR(ROWCOUNT => 10));

--create a JavaScript table UDF that returns country ISO codes
CREATE FUNCTION COUNTRYISO()
RETURNS TABLE(COUNTRYCODE STRING, COUNTRYNAME STRING)
LANGUAGE JAVASCRIPT
AS
$$
{
    processRow: function f(row, rowWriter, context) {
        rowWriter.writeRow({COUNTRYCODE: "AU", COUNTRYNAME: "Australia"});
        rowWriter.writeRow({COUNTRYCODE: "NZ", COUNTRYNAME: "New Zealand"});
        rowWriter.writeRow({COUNTRYCODE: "PK", COUNTRYNAME: "Pakistan"});
    }
}
$$;

--call the COUNTRYISO table UDF
SELECT *
FROM TABLE(COUNTRYISO());

--filter the output of the COUNTRYISO table UDF
SELECT COUNTRYCODE
FROM TABLE(COUNTRYISO())
WHERE COUNTRYCODE = 'PK';

--create a JavaScript table UDF that returns string length
CREATE FUNCTION STRINGSIZE(INPUT STRING)
RETURNS TABLE(SIZE FLOAT)
LANGUAGE JAVASCRIPT
AS
$$
{
    processRow: function f(row, rowWriter, context) {
        rowWriter.writeRow({SIZE: row.INPUT.length});
    }
}
$$;

--call the STRINGSIZE table UDF with a single value
SELECT *
FROM TABLE(STRINGSIZE('TEST'));

--join the STRINGSIZE table UDF to process multiple rows
SELECT *
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION,
TABLE(STRINGSIZE(N_NAME));
