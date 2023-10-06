FROM python:3.10.11-slim

RUN pip install --no-cache-dir -U pip \
    && pip install --no-cache-dir boto3==1.28.57

COPY data data
COPY data_generator.py data_generator.py
