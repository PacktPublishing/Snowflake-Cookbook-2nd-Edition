--connect to the cookbook PostgreSQL database before running this script

--set the search path
SET search_path TO crm;

--insert sample customers
INSERT INTO customers VALUES
(1, 'Jane', 'Doe', 'jane.doe@example.com', CURRENT_TIMESTAMP),
(2, 'John', 'Smith', 'john.smith@example.com', CURRENT_TIMESTAMP);

--insert sample products
INSERT INTO products VALUES
(100, 'Snowflake T-Shirt', 25.00, CURRENT_TIMESTAMP),
(200, 'DataOps Mug', 15.00, CURRENT_TIMESTAMP);

--insert sample orders
INSERT INTO orders VALUES
(1000, 1, CURRENT_TIMESTAMP, 'NEW'),
(1001, 2, CURRENT_TIMESTAMP, 'NEW');

--insert sample order items
INSERT INTO order_items VALUES
(1, 1000, 100, 2, 25.00),
(2, 1001, 200, 1, 15.00);

--verify source data
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
