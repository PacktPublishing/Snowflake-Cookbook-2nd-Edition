--create and set the database
CREATE DATABASE CHAPTER9;

USE DATABASE CHAPTER9;

--create the credit table
CREATE TABLE C9R4_CREDIT
(
    ACCOUNT INT,
    AMOUNT INT,
    PAYMENT_TS TIMESTAMP
);

--create the debit table
CREATE TABLE C9R4_DEBIT
(
    ACCOUNT INT,
    AMOUNT INT,
    PAYMENT_TS TIMESTAMP
);

--create a stored procedure that commits or rolls back a transaction
CREATE OR REPLACE PROCEDURE SP_ADJUST_CREDIT
(
    PARAM_ACCT FLOAT,
    PARAM_AMT FLOAT
)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
var ret_val = "";
var sql_command_debit = "";
var sql_command_credit = "";

sql_command_debit = "INSERT INTO CHAPTER9.PUBLIC.C9R4_DEBIT VALUES ("
    + PARAM_ACCT + "," + PARAM_AMT + ", CURRENT_TIMESTAMP());";

sql_command_credit = "INSERT INTO CHAPTER9.PUBLIC.C9R4_CREDIT " +
    "SELECT * FROM CHAPTER9.PUBLIC.C9R4_DEBIT " +
    "WHERE CHAPTER9.PUBLIC.C9R4_DEBIT.PAYMENT_TS > " +
    "(SELECT IFF(MAX(PAYMENT_TS) IS NULL, TO_DATE('1970-01-01'), MAX(PAYMENT_TS)) " +
    "FROM CHAPTER9.PUBLIC.C9R4_CREDIT);";

snowflake.execute({sqlText: "BEGIN WORK;"});

try {
    snowflake.execute({sqlText: sql_command_debit});

    if ((PARAM_ACCT % 2) === 0) {
        snowflake.execute({sqlText: "DELETE FROM TABLE_0123456789;"});
    }

    snowflake.execute({sqlText: sql_command_credit});
    snowflake.execute({sqlText: "COMMIT WORK;"});

    ret_val = "Succeeded";
} catch (err) {
    snowflake.execute({sqlText: "ROLLBACK WORK;"});
    ret_val = "Failed: " + err.message;
}

return ret_val;
$$;

--disable autocommit for clearer transaction control
ALTER SESSION SET AUTOCOMMIT = FALSE;

--execute the procedure with an odd account number
CALL SP_ADJUST_CREDIT(1, 100);

--verify both tables were updated
SELECT *
FROM C9R4_CREDIT;

SELECT *
FROM C9R4_DEBIT;

--execute the procedure with an even account number to trigger rollback
CALL SP_ADJUST_CREDIT(2, 200);

--verify the failed transaction did not add new rows
SELECT *
FROM C9R4_CREDIT;

SELECT *
FROM C9R4_DEBIT;

--re-enable autocommit
ALTER SESSION SET AUTOCOMMIT = TRUE;
