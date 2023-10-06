import boto3
import os

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


if __name__ == "__main__":
    root_file_path = "./data"
    file_name_list = [
        "2019-Oct.csv",
    ]

for file_name in file_name_list:
    local_csv_file_path = os.path.join(root_file_path, file_name)
    BOTO3_CLIENT.upload_file(
        local_csv_file_path,
        MINIO_BUCKET,
        file_name,
    )
