--connect to the cookbook PostgreSQL database before running this script

--set the search path
SET search_path TO crm;

--create a PostgreSQL publication for logical replication
CREATE PUBLICATION Openflow_pub FOR ALL TABLES;

--confirm the expected tables are included in the publication
SELECT * FROM pg_publication_tables;

--create the logical replication slot using the pgoutput plugin
SELECT pg_create_logical_replication_slot(
  'Openflow_pgoutput_slot',
  'pgoutput'
);
