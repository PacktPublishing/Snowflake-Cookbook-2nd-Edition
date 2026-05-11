# import Snowpark libraries
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col

# retrieve the active Snowpark session
session = get_active_session()

# load the CUSTOMER table into a DataFrame
df = session.table("SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER")

# display sample rows
df.show()

# filter the DataFrame
df_filtered = df.filter(col("C_NATIONKEY") == 14)
df_filtered.show()

# select relevant columns
df_selected = df_filtered.select(
    col("C_CUSTKEY"),
    col("C_NAME"),
    col("C_ACCTBAL")
)
df_selected.show()

# sort by account balance descending
df_sorted = df_selected.sort(col("C_ACCTBAL").desc())
df_sorted.show()
