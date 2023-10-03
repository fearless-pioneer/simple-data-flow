FROM python:3.10.11-slim

RUN apt-get update && apt-get install -y axel

RUN pip install boto3==1.28.57 "ray[default]==2.7.0"

COPY data_generator.py data_generator.py
