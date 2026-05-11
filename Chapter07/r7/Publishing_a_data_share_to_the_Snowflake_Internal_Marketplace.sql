--use ACCOUNTADMIN to prepare the existing share for listing
USE ROLE ACCOUNTADMIN;

--verify that the share exists
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
