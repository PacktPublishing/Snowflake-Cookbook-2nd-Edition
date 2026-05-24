--generate a set of calendar dates
SELECT
    (TO_DATE('2020-01-01') + SEQ4()) AS CAL_DT
FROM TABLE(GENERATOR(ROWCOUNT => 365));

--extract basic calendar components
SELECT
    (TO_DATE('2020-01-01') + SEQ4()) AS CAL_DT,
    DATE_PART(DAY, CAL_DT) AS CAL_DOM,
    DATE_PART(MONTH, CAL_DT) AS CAL_MONTH,
    DATE_PART(YEAR, CAL_DT) AS CAL_YEAR
FROM TABLE(GENERATOR(ROWCOUNT => 365));

--calculate first and last day of month
SELECT
    (TO_DATE('2021-01-01') + SEQ4()) AS CAL_DT,
    DATE_PART(DAY, CAL_DT) AS CAL_DOM,
    DATE_PART(MONTH, CAL_DT) AS CAL_MONTH,
    DATE_PART(YEAR, CAL_DT) AS CAL_YEAR,
    DATE_TRUNC('MONTH', CAL_DT) AS CAL_FIRST_DOM,
    DATEADD(
        'DAY',
        -1,
        DATEADD('MONTH', 1, DATE_TRUNC('MONTH', CAL_DT))
    ) AS CAL_LAST_DOM
FROM TABLE(GENERATOR(ROWCOUNT => 365));

--add month name using DECODE
SELECT
    (TO_DATE('2021-01-01') + SEQ4()) AS CAL_DT,
    DATE_PART(DAY, CAL_DT) AS CAL_DOM,
    DATE_PART(MONTH, CAL_DT) AS CAL_MONTH,
    DATE_PART(YEAR, CAL_DT) AS CAL_YEAR,
    DATE_TRUNC('MONTH', CAL_DT) AS CAL_FIRST_DOM,
    DATEADD(
        'DAY',
        -1,
        DATEADD('MONTH', 1, DATE_TRUNC('MONTH', CAL_DT))
    ) AS CAL_LAST_DOM,
    DECODE(
        CAL_MONTH,
        1, 'January',
        2, 'February',
        3, 'March',
        4, 'April',
        5, 'May',
        6, 'June',
        7, 'July',
        8, 'August',
        9, 'September',
        10, 'October',
        11, 'November',
        12, 'December'
    ) AS CAL_MONTH_NAME
FROM TABLE(GENERATOR(ROWCOUNT => 365));

--add quarter end date
SELECT
    (TO_DATE('2021-01-01') + SEQ4()) AS CAL_DT,
    DATE_PART(DAY, CAL_DT) AS CAL_DOM,
    DATE_PART(MONTH, CAL_DT) AS CAL_MONTH,
    DATE_PART(YEAR, CAL_DT) AS CAL_YEAR,
    DATE_TRUNC('MONTH', CAL_DT) AS CAL_FIRST_DOM,
    DATEADD(
        'DAY',
        -1,
        DATEADD('MONTH', 1, DATE_TRUNC('MONTH', CAL_DT))
    ) AS CAL_LAST_DOM,
    DECODE(
        CAL_MONTH,
        1, 'January',
        2, 'February',
        3, 'March',
        4, 'April',
        5, 'May',
        6, 'June',
        7, 'July',
        8, 'August',
        9, 'September',
        10, 'October',
        11, 'November',
        12, 'December'
    ) AS CAL_MONTH_NAME,
    DATEADD(
        'DAY',
        -1,
        DATEADD('MONTH', 3, DATE_TRUNC('QUARTER', CAL_DT))
    ) AS CAL_QTR_END_DT
FROM TABLE(GENERATOR(ROWCOUNT => 365));
