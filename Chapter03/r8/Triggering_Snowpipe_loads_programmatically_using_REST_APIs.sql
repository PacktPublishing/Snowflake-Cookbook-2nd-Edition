--placeholder for REST API-based Snowpipe triggering

--create or reuse a pipe that can be triggered programmatically
CREATE OR REPLACE PIPE TX_LD_PIPE_REST
AS
COPY INTO TRANSACTIONS
FROM @SP_TRX_STAGE
FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1);

--check pipe metadata
SHOW PIPES LIKE '%TX_LD_PIPE_REST%';

--check pipe status
SELECT SYSTEM$PIPE_STATUS('TX_LD_PIPE_REST');
