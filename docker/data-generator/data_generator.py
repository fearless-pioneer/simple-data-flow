import boto3
import os
import wget
import gzip
from delta import configure_spark_with_delta_pip
from pyspark.sql import SparkSession

MINIO_BUCKET = "data"
MINIO_ENDPOINT = "http://minio:9000"
MINIO_ACCESS_KEY_ID = "minio"
MINIO_SECRET_ACCESS_KEY = "minio123"

if __name__ == "__main__":
    BOTO3_CLIENT = boto3.client(
        "s3",
        endpoint_url=MINIO_ENDPOINT,
        aws_access_key_id=MINIO_ACCESS_KEY_ID,
        aws_secret_access_key=MINIO_SECRET_ACCESS_KEY,
    )

    root_url = "https://data.rees46.com/datasets/marketplace"
    file_name_list = [
                        "2019-Oct.csv.gz", "2019-Nov.csv.gz", "2019-Dec.csv.gz",
                        "2020-Jan.csv.gz", "2020-Feb.csv.gz", "2020-Mar.csv.gz", "2020-Apr.csv.gz"
                      ]
    for file_name in file_name_list:
        url = os.path.join(root_url, file_name)
        wget.download(url)
        
        with gzip.open(file_name, 'rb') as f:
            csv_file_data = f.read().decode('utf-8')
        
        csv_file_name = file_name[:-3]    
        with open(csv_file_name, 'w', encoding='utf-8') as csv_file:
            csv_file.write(csv_file_data)
            
        BOTO3_CLIENT.upload_file(csv_file_name, MINIO_BUCKET, csv_file_name)
        
        os.remove(file_name)
        os.remove(csv_file_name)
    
    spark = configure_spark_with_delta_pip(SparkSession.builder).getOrCreate()
    df_orders = spark.read.format("csv").load("s3a://data/", header=True)
    (
        df_orders.limit
        .write.mode("overwrite")
        .option("compression", "snappy")
        .option("path", "s3a://ecommerce/data.delta")
        .format("delta")
        .partitionBy("user_id")
        .saveAsTable("ecommerce_table")
    )
    