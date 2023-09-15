"""Spark test code."""

# %%
from delta import configure_spark_with_delta_pip
from pyspark.sql import SparkSession

# %%
spark = configure_spark_with_delta_pip(SparkSession.builder).getOrCreate()

# %%
spark.range(500).write.format("delta").save("s3a://data/test", mode="overwrite")
