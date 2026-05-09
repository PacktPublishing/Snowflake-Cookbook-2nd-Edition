--PostgreSQL source setup

--create the source database
CREATE DATABASE cookbook;

--create the source schema
CREATE SCHEMA IF NOT EXISTS crm;
SET search_path TO crm;

--create source tables
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(25),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER,
    unit_price NUMERIC(10,2),
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

--insert sample source data
INSERT INTO customers VALUES
(1, 'Jane', 'Doe', 'jane.doe@example.com', CURRENT_TIMESTAMP),
(2, 'John', 'Smith', 'john.smith@example.com', CURRENT_TIMESTAMP);

INSERT INTO products VALUES
(100, 'Snowflake T-Shirt', 25.00, CURRENT_TIMESTAMP),
(200, 'DataOps Mug', 15.00, CURRENT_TIMESTAMP);

INSERT INTO orders VALUES
(1000, 1, CURRENT_TIMESTAMP, 'NEW'),
(1001, 2, CURRENT_TIMESTAMP, 'NEW');

INSERT INTO order_items VALUES
(1, 1000, 100, 2, 25.00),
(2, 1001, 200, 1, 15.00);

--verify source data
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

--create a PostgreSQL publication for logical replication
CREATE PUBLICATION Openflow_pub FOR ALL TABLES;

--confirm tables included in the publication
SELECT * FROM pg_publication_tables;

--create the logical replication slot
SELECT pg_create_logical_replication_slot(
    'Openflow_pgoutput_slot',
    'pgoutput'
);

--Snowflake target setup

--create the target database
CREATE DATABASE OPENFLOW_EX;
USE DATABASE OPENFLOW_EX;

--create a schema for network rules
CREATE SCHEMA IF NOT EXISTS NETWORK;
USE SCHEMA NETWORK;

--create a dedicated role for Openflow
CREATE ROLE IF NOT EXISTS OPENFLOW_ROLE;

--grant database access to the role
GRANT USAGE ON DATABASE OPENFLOW_EX TO ROLE OPENFLOW_ROLE;

--grant warehouse usage to the role
GRANT USAGE ON WAREHOUSE <existing_warehouse> TO ROLE OPENFLOW_ROLE;

--grant the role to the Snowflake user used for Openflow
GRANT ROLE OPENFLOW_ROLE TO USER <Openflow_user>;

--use the Openflow role
USE ROLE OPENFLOW_ROLE;

--create a network rule for the PostgreSQL RDS endpoint
CREATE OR REPLACE NETWORK RULE postgres_rds_rule
    MODE = EGRESS
    TYPE = HOST_PORT
    VALUE_LIST = ('<rds-endpoint>:5432');

--create an external access integration for Openflow
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION postgres_ext_access
    ALLOWED_NETWORK_RULES = (postgres_rds_rule)
    ENABLED = TRUE;

--grant usage on the external access integration
GRANT USAGE ON INTEGRATION postgres_ext_access TO ROLE OPENFLOW_ROLE;

--verify Openflow-created schemas after ingestion starts
USE DATABASE OPENFLOW_EX;
SHOW SCHEMAS;
