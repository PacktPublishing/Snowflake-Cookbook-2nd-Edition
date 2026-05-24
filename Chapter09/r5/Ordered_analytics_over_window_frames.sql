--create and set the database
CREATE DATABASE CHAPTER9;

USE DATABASE CHAPTER9;

--create a view with sample customer deposit activity
CREATE OR REPLACE VIEW C9R5_VW AS
SELECT
    MOD(SEQ4(), 5) AS CUSTOMER_ID,
    (MOD(UNIFORM(1, 100, RANDOM()), 5) + 1) * 100 AS DEPOSIT,
    DATEADD(DAY, '-' || SEQ4(), CURRENT_DATE()) AS DEPOSIT_DT
FROM TABLE(GENERATOR(ROWCOUNT => 365));

--review generated sample data
SELECT *
FROM C9R5_VW;

--compare each deposit to the sum of the two previous deposits
SELECT
    CUSTOMER_ID,
    DEPOSIT_DT,
    DEPOSIT,
    DEPOSIT >
        COALESCE(
            SUM(DEPOSIT) OVER
            (
                PARTITION BY CUSTOMER_ID
                ORDER BY DEPOSIT_DT
                ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING
            ),
            0
        ) AS HI_DEPOSIT_ALERT
FROM C9R5_VW
ORDER BY
    CUSTOMER_ID,
    DEPOSIT_DT DESC;

--compare each deposit to the historical average of previous deposits
SELECT
    CUSTOMER_ID,
    DEPOSIT_DT,
    DEPOSIT,
    COALESCE(
        AVG(DEPOSIT) OVER
        (
            PARTITION BY CUSTOMER_ID
            ORDER BY DEPOSIT_DT
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ),
        0
    ) AS PAST_AVERAGE_DEPOSIT,
    DEPOSIT > PAST_AVERAGE_DEPOSIT AS HI_DEPOSIT_ALERT
FROM C9R5_VW
WHERE CUSTOMER_ID = 3
ORDER BY
    CUSTOMER_ID,
    DEPOSIT_DT DESC;
