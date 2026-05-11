# import Snowpark libraries
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col, sum as sum_

# retrieve the active Snowpark session
session = get_active_session()

# load the ORDERS table into a DataFrame
orders_df = session.table("SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS")

# display sample rows
orders_df.show()

# aggregate total revenue by customer
customer_revenue_df = orders_df.group_by(col("O_CUSTKEY")) \
    .agg(sum_(col("O_TOTALPRICE")).alias("TOTAL_REVENUE"))

customer_revenue_df.show()

# create and set a database and schema for the output table
session.sql("CREATE OR REPLACE DATABASE C10_R6").collect()
session.sql("CREATE OR REPLACE SCHEMA C10_R6.PUBLIC").collect()
session.sql("USE DATABASE C10_R6").collect()
session.sql("USE SCHEMA PUBLIC").collect()

# write aggregated results to a new Snowflake table
customer_revenue_df.write.save_as_table(
    "CUSTOMER_REVENUE",
    mode="overwrite"
)

# confirm the table was created successfully
session.table("CUSTOMER_REVENUE").show()
