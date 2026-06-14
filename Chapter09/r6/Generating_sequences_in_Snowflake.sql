--create a database and basic sequence
CREATE DATABASE C9_R6;

CREATE SEQUENCE SEQ1;

--retrieve the first value from the sequence
SELECT SEQ1.NEXTVAL;

--retrieve the next value from the sequence
SELECT SEQ1.NEXTVAL;

--request multiple sequence values in a single statement
SELECT
    SEQ1.NEXTVAL,
    SEQ1.NEXTVAL,
    SEQ1.NEXTVAL;

--create a sequence with custom starting and increment values
CREATE SEQUENCE SEQ_SPECIAL
    START WITH = 777
    INCREMENT BY = 100;

--test the custom sequence
SELECT
    SEQ_SPECIAL.NEXTVAL,
    SEQ_SPECIAL.NEXTVAL,
    SEQ_SPECIAL.NEXTVAL;

--create a table for explicit sequence-generated identifiers
CREATE TABLE T1
(
    CUSTOMER_ID INTEGER,
    CUSTOMER_NAME STRING
);

--create a sequence for T1
CREATE SEQUENCE T1_SEQ;

--insert rows using explicit calls to the sequence
INSERT INTO T1
SELECT
    T1_SEQ.NEXTVAL,
    RANDSTR(10, RANDOM())
FROM TABLE(GENERATOR(ROWCOUNT => 500));

--query T1
SELECT *
FROM T1;

--create a sequence for default column values
CREATE SEQUENCE T2_SEQ;

--create a table using sequence as the default value
CREATE TABLE T2
(
    CUSTOMER_ID INTEGER DEFAULT T2_SEQ.NEXTVAL,
    CUSTOMER_NAME STRING
);

--insert rows while omitting CUSTOMER_ID
INSERT INTO T2
    (CUSTOMER_NAME)
SELECT RANDSTR(10, RANDOM())
FROM TABLE(GENERATOR(ROWCOUNT => 500));

--query T2
SELECT *
FROM T2;
