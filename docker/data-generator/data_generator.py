import pandas as pd
import boto3
import os
import gzip
import subprocess
from delta import configure_spark_with_delta_pip
from pyspark.sql import SparkSession
import ray

MINIO_BUCKET = "data"
MINIO_ENDPOINT = "http://minio:9000"
MINIO_ACCESS_KEY_ID = "minio"
MINIO_SECRET_ACCESS_KEY = "minio123"

BOTO3_CLIENT = boto3.client(
    "s3",
    endpoint_url=MINIO_ENDPOINT,
    aws_access_key_id=MINIO_ACCESS_KEY_ID,
    aws_secret_access_key=MINIO_SECRET_ACCESS_KEY,
)

@ray.remote(max_calls=1)
def download_upload_data(file_name):
    root_url = "https://data.rees46.com/datasets/marketplace"
    url = os.path.join(root_url, file_name)
    subprocess.run(["axel", url])
    
    with gzip.open(file_name, 'rb') as gzipped_file:
       df = pd.read_csv(gzipped_file)
    os.remove(file_name)
    return df
    
if __name__ == "__main__":
    file_name_list = [
                        "2019-Oct.csv.gz", "2019-Nov.csv.gz", "2019-Dec.csv.gz",
                        "2020-Jan.csv.gz", "2020-Feb.csv.gz", "2020-Mar.csv.gz", "2020-Apr.csv.gz"
                      ]
    
    ray.init(log_to_driver=False)
    obj_id = [download_upload_data.remote(file_name) for file_name in file_name_list]
    raw_df_list = ray.get(obj_id)
    total_raw_df = pd.concat(raw_df_list, ignore_index=True)
    
    spark = configure_spark_with_delta_pip(SparkSession.builder).getOrCreate()
    spark_df = spark.createDataFrame(total_raw_df)
    (
        spark_df.write.mode("overwrite")
        .option("compression", "snappy")
        .option("path", "s3a://data/data.delta")
        .format("delta")
        .partitionBy("user_id")
        .saveAsTable("ecommerce_table")
    )
    