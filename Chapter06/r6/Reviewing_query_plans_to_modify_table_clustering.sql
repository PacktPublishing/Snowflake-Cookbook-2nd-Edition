--create the database and transactions table
CREATE DATABASE C6_R6;

CREATE TABLE TRANSACTIONS
(
    TXN_ID STRING,
    TXN_DATE DATE,
    CUSTOMER_ID STRING,
    QUANTITY DECIMAL(20),
    PRICE DECIMAL(30,2),
    COUNTRY_CD STRING
);

--insert 10 million generated transaction rows
--run this statement 8-10 times to create enough data for the example
INSERT INTO TRANSACTIONS
SELECT
    UUID_STRING() AS TXN_ID,
    DATEADD(DAY, UNIFORM(1, 500, RANDOM()) * -1, '2020-10-15') AS TXN_DATE,
    UUID_STRING() AS CUSTOMER_ID,
    UNIFORM(1, 10, RANDOM()) AS QUANTITY,
    UNIFORM(1, 200, RANDOM()) AS PRICE,
    RANDSTR(2, RANDOM()) AS COUNTRY_CD
FROM TABLE(GENERATOR(ROWCOUNT => 10000000));

--run a query filtering on TXN_DATE before clustering
SELECT *
FROM TRANSACTIONS
WHERE TXN_DATE BETWEEN DATEADD(DAY, -31, '2020-10-15')
                   AND '2020-10-15';

--cluster the table by TXN_DATE
ALTER TABLE TRANSACTIONS CLUSTER BY (TXN_DATE);

--rerun the query after reclustering
SELECT *
FROM TRANSACTIONS
WHERE TXN_DATE BETWEEN DATEADD(DAY, -31, '2020-10-15')
                   AND '2020-10-15';
