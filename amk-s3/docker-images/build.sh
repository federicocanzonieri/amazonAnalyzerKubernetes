#!/bin/bash

echo "Check For spark ..."
if [ "$(ls -A spark/setup/)" ]; then
     echo "Spark's found"
else
    echo "Installing Spark's dependencies "
    mkdir spark/setup
    wget https://downloads.apache.org/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
    mv spark-3.1.2-bin-hadoop3.2.tgz spark/setup/;
fi

echo "Building images docker ..."
cd elastic
docker build -t amk-elastic .
cd kibana
docker build -t amk-kibana .
cd spark
docker build -t amk-spark .
cd python
docker build -t amk-python .
cd logstash
docker build -t amk-logstash .
echo "Done"