# %%
from delta import configure_spark_with_delta_pip
from pyspark.sql import SparkSession

# %%
spark = configure_spark_with_delta_pip(SparkSession.builder).getOrCreate()

# %%
df_orders = spark.read.format("csv").load("s3a://mydata/2019-Oct.csv", header=True)

# %%
df_orders

# %%
display(df_orders.limit(10).toPandas())

# %%
# sql을 사용한다면 아래와 같을 거 같아요
# # %%sparksql
# CREATE TABLE IF NOT EXISTS delta.`s3://mydata` (
#     `event_time` TIMESTAMP
#     `event_type` STRING
#     `product_id` int64
#     `category_id` int64
#     `category_code` STRING
#     `brand` STRING
#     `price` float64
#     `user_id` int64
#     `user_session` STRING
# )
# USING DELTA
# PARTITIONED BY (event_time)
# LOCATION 's3://mydata/'
# TBLPROPERTIES (
#     'delta.compatibility.symlinkFormatManifest.enabled'='true'
# )

# %%
# 한번에 너무 많이 넣으면 디스크 에러가 발생해서 일단은 limit 설정했습니다.
(
    df_orders.limit(10)
    .write.mode("overwrite")
    .option("compression", "snappy")
    .option("path", "s3a://mydata/data.delta")
    .format("delta")
    .partitionBy("event_time")
    .saveAsTable('ecommerce_table')
)

# %%
