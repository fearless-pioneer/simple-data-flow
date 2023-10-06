FROM python:3.10.11-slim

RUN apt-get update \
    && pip install boto3==1.28.57\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

COPY data data    
COPY data_generator.py data_generator.py
