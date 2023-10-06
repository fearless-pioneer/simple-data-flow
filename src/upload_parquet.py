# %%
df = spark.read.format("csv").load("s3a://data/2019-Oct.csv", header=True)

# %%
(df.write.mode("overwrite").option("compression", "snappy").parquet("s3a://data/data.parquet"))

# %%
