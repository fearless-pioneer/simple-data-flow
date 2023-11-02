FROM python:3.10.11-slim

USER root
ARG openjdk_version=17
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    "openjdk-${openjdk_version}-jre-headless" \
    ca-certificates-java && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV SPARK_VERSION=3.3.3
ENV SPARK_HOME=/usr/local/spark
ENV SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH="${PATH}:${SPARK_HOME}/bin"

RUN curl -O https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz \
    && tar -xvzf spark-$SPARK_VERSION-bin-hadoop3.tgz \
    && rm -rf spark-$SPARK_VERSION-bin-hadoop3.tgz \
    && mv spark-$SPARK_VERSION-bin-hadoop3/ /usr/local/ \
    && rm -rf /usr/local/spark \
    && rm -rf /usr/local/spark-3.3.0-bin-hadoop3 \
    && ln -s /usr/local/spark-$SPARK_VERSION-bin-hadoop3 /usr/local/spark

RUN curl -O https://repo1.maven.org/maven2/software/amazon/awssdk/s3/2.18.41/s3-2.18.41.jar \
    && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.12.367/aws-java-sdk-1.12.367.jar \
    && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.2.0/delta-core_2.12-2.2.0.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/delta-storage/2.2.0/delta-storage-2.2.0.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar \
    && mv s3-2.18.41.jar /usr/local/spark/jars \
    && mv aws-java-sdk-1.12.367.jar /usr/local/spark/jars \
    && mv aws-java-sdk-bundle-1.11.1026.jar /usr/local/spark/jars \
    && mv delta-core_2.12-2.2.0.jar /usr/local/spark/jars \
    && mv delta-storage-2.2.0.jar /usr/local/spark/jars \
    && mv hadoop-aws-3.3.2.jar /usr/local/spark/jars

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir delta-spark==2.2.0

COPY data_uploader.py data_uploader.py
