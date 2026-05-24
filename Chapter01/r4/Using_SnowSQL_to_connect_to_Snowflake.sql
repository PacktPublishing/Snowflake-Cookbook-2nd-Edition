--verify SnowSQL installation
snowsql -v

--connect to Snowflake
snowsql -a <account_identifier> -u <username>

--check Snowflake version
SELECT CURRENT_VERSION();

--check current account
SELECT CURRENT_ACCOUNT();

--set warehouse, database, and schema context
USE WAREHOUSE DEFAULT_WH;
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCDS_SF10TCL;

--query sample data
SELECT COUNT(*) FROM ITEM;

--exit SnowSQL
!exit
