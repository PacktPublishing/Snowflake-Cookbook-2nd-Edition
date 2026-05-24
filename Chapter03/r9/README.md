# r9 – Building managed data ingestion pipelines using Openflow

This recipe demonstrates how to configure PostgreSQL logical replication and ingest data continuously into Snowflake using Openflow.

## Files

- `postgres_database_setup.sql`
- `postgres_schema_and_tables.sql`
- `postgres_sample_data.sql`
- `postgres_logical_replication.sql`
- `snowflake_openflow_setup.sql`
- `snowflake_openflow_validation.sql`

## Recommended execution order

1. Run `postgres_database_setup.sql` in PostgreSQL.
2. Connect to the `cookbook` PostgreSQL database.
3. Run `postgres_schema_and_tables.sql` in PostgreSQL.
4. Run `postgres_sample_data.sql` in PostgreSQL.
5. Run `postgres_logical_replication.sql` in PostgreSQL.
6. Run `snowflake_openflow_setup.sql` in Snowflake.
7. Configure the Openflow deployment, runtime, connector, destination, ingestion, and source parameters in Openflow.
8. Start the Openflow PostgreSQL process group.
9. Run `snowflake_openflow_validation.sql` in Snowflake to confirm that the replicated schema and tables were created.

## Placeholders to replace

- `<existing_warehouse>`
- `<Openflow_user>`
- `<rds-endpoint>`
