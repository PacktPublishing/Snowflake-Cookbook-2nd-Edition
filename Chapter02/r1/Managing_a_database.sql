--create a new database with the default lifecycle settings
CREATE DATABASE OUR_FIRST_DATABASE
COMMENT = 'Our first database';

--verify the database was created and review its default properties
SHOW DATABASES LIKE 'OUR_FIRST_DATABASE';

--create a production database with extended Time Travel retention
CREATE DATABASE PRODUCTION_DATABASE
DATA_RETENTION_TIME_IN_DAYS = 15
COMMENT = 'Critical production database';

--verify the production database retention setting
SHOW DATABASES LIKE 'PRODUCTION_DATABASE';

--create a transient database for temporary ELT processing
CREATE TRANSIENT DATABASE TEMPORARY_DATABASE
DATA_RETENTION_TIME_IN_DAYS = 0
COMMENT = 'Temporary database for ELT processing';

--verify the transient database settings
SHOW DATABASES LIKE 'TEMPORARY_DATABASE';

--change the Time Travel retention setting after database creation
ALTER DATABASE TEMPORARY_DATABASE
SET DATA_RETENTION_TIME_IN_DAYS = 1;

--verify the updated retention setting
SHOW DATABASES LIKE 'TEMPORARY_DATABASE';
