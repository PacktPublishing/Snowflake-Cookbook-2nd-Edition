--create a database and table for DATE examples
CREATE DATABASE C9_R1;

CREATE TABLE C9R1_DATE_TEST
(
    DATE_ID INTEGER,
    DATE_VALUE DATE
);

--insert a date value from a string
INSERT INTO C9R1_DATE_TEST
    (DATE_ID, DATE_VALUE)
VALUES
    (1, TO_DATE('2019-12-19','YYYY-MM-DD'));

--insert a timestamp value into a DATE column
INSERT INTO C9R1_DATE_TEST
    (DATE_ID, DATE_VALUE)
VALUES
    (2, TO_TIMESTAMP('2019.12.21 04:00:00', 'YYYY.MM.DD HH:MI:SS'));

--insert a time-only value converted to DATE
INSERT INTO C9R1_DATE_TEST
    (DATE_ID, DATE_VALUE)
VALUES
    (3, TO_DATE('08:00:00', 'HH:MI:SS'));

--query the DATE test table
SELECT *
FROM C9R1_DATE_TEST;

--create a table with a TIMESTAMP column
CREATE TABLE C9R1_TS_TEST
(
    TS_ID INTEGER,
    TS_VALUE TIMESTAMP
);

--show session timezone parameters
SHOW PARAMETERS LIKE '%TIMEZONE%' IN SESSION;

--set the session timezone
ALTER SESSION SET TIMEZONE = 'Australia/Sydney';

--show updated session timezone parameters
SHOW PARAMETERS LIKE '%TIMEZONE%' IN SESSION;

--insert a timestamp value
INSERT INTO C9R1_TS_TEST
    (TS_ID, TS_VALUE)
VALUES
    (1, '2020-11-19 22:00:00.000');

--query the timestamp test table
SELECT *
FROM C9R1_TS_TEST;

--configure timestamp type mapping and session timezone
ALTER SESSION SET TIMESTAMP_TYPE_MAPPING = 'TIMESTAMP_LTZ';
ALTER SESSION SET TIMEZONE = 'Australia/Sydney';

--create a timestamp test table
CREATE OR REPLACE TABLE C9R1_TEST_TS
(
    TS TIMESTAMP
);

--insert a timestamp value without an explicit timezone
INSERT INTO C9R1_TEST_TS
VALUES
    ('2020-11-19 22:00:00.000');

--query the timestamp value
SELECT TS
FROM C9R1_TEST_TS;

--recreate the timestamp test table
CREATE OR REPLACE TABLE C9R1_TEST_TS
(
    TS TIMESTAMP
);

--insert a timestamp value with an explicit timezone offset
INSERT INTO C9R1_TEST_TS
VALUES
    ('2020-11-19 22:00:00.000 +0800');

--query the adjusted timestamp value
SELECT TS
FROM C9R1_TEST_TS;
