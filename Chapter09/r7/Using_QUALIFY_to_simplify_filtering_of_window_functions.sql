--create a sample sales table
CREATE OR REPLACE TABLE C9_R7_SALES
(
    CUSTOMER_ID INTEGER,
    ORDER_DT DATE,
    SALES_AMT NUMBER(10,2)
);

--insert sample sales rows
INSERT INTO C9_R7_SALES VALUES
    (101, '2026-01-05', 125.00),
    (101, '2026-02-10', 175.00),
    (101, '2026-03-15', 150.00),
    (102, '2026-01-12', 220.00),
    (102, '2026-02-18', 220.00),
    (103, '2026-01-08', 95.00),
    (103, '2026-03-01', 140.00),
    (103, '2026-03-20', 140.00);

--review the source data
SELECT *
FROM C9_R7_SALES
ORDER BY CUSTOMER_ID, ORDER_DT;

--return the most recent row for each customer
SELECT
    CUSTOMER_ID,
    ORDER_DT,
    SALES_AMT
FROM C9_R7_SALES
QUALIFY ROW_NUMBER() OVER
    (
        PARTITION BY CUSTOMER_ID
        ORDER BY ORDER_DT DESC
    ) = 1;

--identify the highest sales value for each customer
SELECT
    CUSTOMER_ID,
    ORDER_DT,
    SALES_AMT
FROM C9_R7_SALES
QUALIFY RANK() OVER
    (
        PARTITION BY CUSTOMER_ID
        ORDER BY SALES_AMT DESC
    ) = 1;

--return the top two rows per customer by sales amount
SELECT
    CUSTOMER_ID,
    ORDER_DT,
    SALES_AMT
FROM C9_R7_SALES
QUALIFY ROW_NUMBER() OVER
    (
        PARTITION BY CUSTOMER_ID
        ORDER BY SALES_AMT DESC
    ) <= 2;

--remove duplicate business rows by keeping the newest occurrence
SELECT
    CUSTOMER_ID,
    ORDER_DT,
    SALES_AMT
FROM C9_R7_SALES
QUALIFY ROW_NUMBER() OVER
    (
        PARTITION BY CUSTOMER_ID, SALES_AMT
        ORDER BY ORDER_DT DESC
    ) = 1;

--traditional subquery approach for comparison
SELECT
    CUSTOMER_ID,
    ORDER_DT,
    SALES_AMT
FROM
(
    SELECT
        CUSTOMER_ID,
        ORDER_DT,
        SALES_AMT,
        ROW_NUMBER() OVER
        (
            PARTITION BY CUSTOMER_ID
            ORDER BY ORDER_DT DESC
        ) AS RN
    FROM C9_R7_SALES
)
WHERE RN = 1;
