#!/bin/bash

echo "Check For spark ..."
if [ "$(ls -A spark-s3/setup/)" ]; then
     echo "Spark's found"
else
    echo "Installing Spark's dependencies "
    mkdir spark-s3/setup
    wget https://downloads.apache.org/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
    mv spark-3.1.2-bin-hadoop3.2.tgz spark-s3/setup/;
fi

echo "Building images docker ..."
cd elastic
docker build -t amk-elastic-search .
cd kibana
docker build -t amk-kibana .
cd spark-s3
docker build -t amk-spark-s3 .
cd python
docker build -t amk-python-s3 .
cd grafana
docker build -t amk-grafana .

# cd logstash

# docker build -t amk-logstash-opensearch .
echo "Done"