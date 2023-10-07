# %%
df = spark.read.format("csv").load("s3a://data/raw", header=True)  # noqa: F821

df.write.mode("overwrite").option("compression", "snappy").parquet("s3a://data/lake/spark_df.parquet")
