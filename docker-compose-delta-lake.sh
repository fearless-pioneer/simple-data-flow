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
    command: ["--s3", "s3://delta-lake"]
    environment:
      - DELTA_LAKE_STORAGE_S3_ACCESS_KEY=minio
      - DELTA_LAKE_STORAGE_S3_SECRET_KEY=minio123
      - DELTA_LAKE_STORAGE_S3_ENDPOINT=http://minio:9000
      - DELTA_LAKE_STORAGE_S3_PATH=s3://delta-lake

  minio:
    image: minio/minio:RELEASE.2021-04-22T15-44-28Z
    container_name: minio
    command: server /data/minio
    environment:
      MINIO_ROOT_USER: minio
      MINIO_ROOT_PASSWORD: minio123
    ports:
      - 9900:9000
    healthcheck:
      test: ["CMD", "curl", "-f", "http://minio:9000/minio/health/live"]
      interval: 10s
      timeout: 5s
      retries: 3

networks:
  default:
    name: simple-data-flow
EOF
