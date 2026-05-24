--create an external stage pointing to an Amazon S3 location
CREATE OR REPLACE STAGE SFUSER_EXT_STAGE
URL = 's3://snowflake-cookbook/Chapter02/r4/';

--list files available in the external stage
LIST @SFUSER_EXT_STAGE;

--create an external table over Parquet files in the stage
CREATE OR REPLACE EXTERNAL TABLE EXT_TBL_USERDATA1
WITH LOCATION = @SFUSER_EXT_STAGE
FILE_FORMAT = (TYPE = PARQUET);

--query the Parquet-backed external table
SELECT *
FROM EXT_TBL_USERDATA1;

--create an external table over CSV files in the stage
CREATE OR REPLACE EXTERNAL TABLE EXT_CARD_DATA
WITH LOCATION = @SFUSER_EXT_STAGE/csv
FILE_FORMAT = (TYPE = CSV)
PATTERN = '.*headless[.]csv';

--query the CSV-backed external table
SELECT *
FROM EXT_CARD_DATA;

--select and cast specific values from the external table
SELECT TOP 5
    VALUE:c3::FLOAT AS CARD_SUM,
    VALUE:c2::STRING AS PERIOD
FROM EXT_CARD_DATA;

--drop the external tables when finished
DROP TABLE EXT_CARD_DATA;
DROP TABLE EXT_TBL_USERDATA1;
