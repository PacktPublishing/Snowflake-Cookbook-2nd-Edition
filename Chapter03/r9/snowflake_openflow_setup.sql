--run in Snowflake

--create the target database for Openflow
USE ROLE ACCOUNTADMIN;

CREATE DATABASE OPENFLOW_EX;
USE DATABASE OPENFLOW_EX;

--create a schema for network objects
CREATE SCHEMA IF NOT EXISTS NETWORK;
USE SCHEMA NETWORK;

--create a dedicated role for Openflow
CREATE ROLE IF NOT EXISTS OPENFLOW_ROLE;

--grant the Openflow role access to the target database
GRANT USAGE ON DATABASE OPENFLOW_EX TO ROLE OPENFLOW_ROLE;

--grant the Openflow role permission to use an existing warehouse
--replace <existing_warehouse> with the warehouse you will use
GRANT USAGE ON WAREHOUSE <existing_warehouse> TO ROLE OPENFLOW_ROLE;

--grant the Openflow role to the user that will configure Openflow
--replace <Openflow_user> with your Snowflake username or Openflow configuration user
GRANT ROLE OPENFLOW_ROLE TO USER <Openflow_user>;

--create a network rule that allows access to the PostgreSQL RDS endpoint
CREATE OR REPLACE NETWORK RULE postgres_rds_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('<rds-endpoint>:5432');

--create the external access integration for Openflow
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION postgres_ext_access
  ALLOWED_NETWORK_RULES = (postgres_rds_rule)
  ENABLED = TRUE;

--grant usage on the external access integration to the Openflow role
GRANT USAGE ON INTEGRATION postgres_ext_access TO ROLE OPENFLOW_ROLE;
