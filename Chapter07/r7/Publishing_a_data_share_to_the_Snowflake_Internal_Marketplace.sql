--provider account: prepare the existing share for an Internal Marketplace listing
USE ROLE ACCOUNTADMIN;

--verify that the share created earlier in the chapter exists
SHOW SHARES;

--confirm the objects granted to the share
SHOW GRANTS TO SHARE SHARE_TRX_DATA;

--the remaining steps are completed in Snowsight:
--1. Navigate to Catalog -> Internal Marketplace.
--2. Select + Create listing.
--3. Enter the listing title: Transaction Data Sample.
--4. Add the following description:
--   Sample transaction dataset shared internally through the Snowflake Internal Marketplace.
--   This dataset contains example transaction records used for demonstrations and internal
--   analytics experimentation.
--5. Add the TRANSACTIONS table from C7_R1.PUBLIC as the data product.
--6. Configure access control and discovery.
--7. Configure request approval using Manage requests in Snowflake.
--8. Add a support contact.
--9. Publish the listing.

--consumer account: after installing the listing, query the installed database
--replace <installed_database> with the database name chosen during installation
SELECT *
FROM <installed_database>.PUBLIC.TRANSACTIONS
LIMIT 10;
