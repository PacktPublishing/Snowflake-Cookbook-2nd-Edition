--convert a number stored as a string to numeric values
SELECT
    '100.2' AS INPUT,
    TO_NUMBER(INPUT),
    TO_NUMBER(INPUT, 12, 2);

--attempt to convert a non-numeric value
SELECT
    'not a number' AS INPUT,
    TO_NUMBER(INPUT);

--use TRY_TO_NUMBER to avoid query failure
SELECT
    'not a number' AS INPUT,
    TRY_TO_NUMBER(INPUT);

--use TRY_TO_NUMBER with a valid numeric input
SELECT
    '100.2' AS INPUT,
    TRY_TO_NUMBER(INPUT);

--convert string values to BOOLEAN TRUE
SELECT
    TO_BOOLEAN('True'),
    TO_BOOLEAN('true'),
    TO_BOOLEAN('tRuE'),
    TO_BOOLEAN('T'),
    TO_BOOLEAN('yes'),
    TO_BOOLEAN('on'),
    TO_BOOLEAN('1');

--convert string values to BOOLEAN FALSE
SELECT
    TO_BOOLEAN('False'),
    TO_BOOLEAN('false'),
    TO_BOOLEAN('FalsE'),
    TO_BOOLEAN('f'),
    TO_BOOLEAN('no'),
    TO_BOOLEAN('off'),
    TO_BOOLEAN('0');

--convert string values to dates
SELECT
    TO_DATE('2020-08-15'),
    DATE('2020-08-15'),
    TO_DATE('15/08/2020','DD/MM/YYYY');

--convert string values to timestamps
SELECT
    TO_TIMESTAMP_NTZ('2020-08-15'),
    TO_TIMESTAMP_NTZ('2020-08-15 14:30:50');
