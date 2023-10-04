FROM python:3.10.11-slim

RUN apt-get update \
    && apt-get install -y axel \
    && pip install boto3==1.28.57 ray==2.7.0 pandas==2.0.3 delta-spark==2.2.0\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*
    
COPY data_generator.py data_generator.py
