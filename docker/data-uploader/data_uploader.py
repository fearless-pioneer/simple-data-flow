from delta import configure_spark_with_delta_pip
from pyspark.sql import SparkSession

if __name__ == '__main__':
    spark = configure_spark_with_delta_pip(SparkSession.builder).getOrCreate()
    df = spark.read.format("csv").load("s3a://data/raw/", header=True)
    df.write.mode("overwrite").option("compression", "snappy").parquet("s3a://data/lake", compression="snappy")
