FROM python:3.10.11-slim

RUN apt-get update && apt-get install -y wget

RUN pip install boto3==1.28.57 wget==3.2

COPY data_generator.py data_generator.py
