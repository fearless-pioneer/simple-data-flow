#!/bin/bash

# Detect the host's architecture (x64 or arm64)
HOST_ARCH=$(uname -m)

# Set the base image based on the host's architecture
if [ "$HOST_ARCH" = "x86_64" ]; then
  BASE_IMAGE="deltaio/delta-docker:0.8.1_2.3.0"
elif [ "$HOST_ARCH" = "aarch64" ]; then
  BASE_IMAGE="deltaio/delta-docker:0.8.1_2.3.0_arm64"
else
  echo "Unsupported architecture: $HOST_ARCH"
  exit 1
fi

# Generate the docker-compose-delta-lake.yml file with the selected base image
cat <<EOF > docker-compose-delta-lake.yml
version: '3.8'

services:
  delta-lake:
    image: $BASE_IMAGE
    container_name: delta-lake
    ports:
      - 9000:9000
    command: ["--s3", "s3a://delta-lake"]
    environment:
      - DELTA_LAKE_STORAGE_S3A_ACCESS_KEY=minioaccesskey
      - DELTA_LAKE_STORAGE_S3A_SECRET_KEY=miniosecretkey
      - DELTA_LAKE_STORAGE_S3A_ENDPOINT=http://minio:9000  # Use the Minio container name
      - DELTA_LAKE_STORAGE_S3A_PATH=s3a://delta-lake

  minio:
    image: minio/minio
    container_name: minio
    ports:
      - 9000:9000
    environment:
      - MINIO_ACCESS_KEY=minioaccesskey
      - MINIO_SECRET_KEY=miniosecretkey
    command: server /data
