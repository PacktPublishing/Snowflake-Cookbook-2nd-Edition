--create a database for JavaScript scalar UDFs
CREATE DATABASE C10_R3;

--create a JavaScript scalar UDF that squares an input value
CREATE FUNCTION SQUARE(VAL FLOAT)
RETURNS FLOAT
LANGUAGE JAVASCRIPT
AS
    'return VAL * VAL;';

--test the SQUARE UDF
SELECT SQUARE(5);

--create a recursive JavaScript scalar UDF for factorials
CREATE FUNCTION FACTORIAL(VAL FLOAT)
RETURNS FLOAT
LANGUAGE JAVASCRIPT
AS
$$
    if (VAL == 1) {
        return VAL;
    }
    else {
        return VAL * FACTORIAL(VAL - 1);
    }
$$;

--test the FACTORIAL UDF
SELECT FACTORIAL(5);
