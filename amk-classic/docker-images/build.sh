#!/bin/bash

echo "Check For spark ..."
if [ "$(ls -A spark/setup/)" ]; then
     echo "Spark's found"
else
    echo "Installing Spark's dependencies "
    rmdir spark/setup
    mkdir spark/setup
    wget https://downloads.apache.org/spark/spark-3.1.3/spark-3.1.3-bin-hadoop2.7.tgz
    mv spark-3.1.3-bin-hadoop2.7.tgz spark/setup/;
fi

echo "Building images docker ..."
cd elastic
docker build -t amk-elastic .
cd ..
cd kafka
docker build -t amk-kafka .
cd ..
cd kibana
docker build -t amk-kibana .
cd ..
cd spark
docker build -t amk-spark .
cd ..
cd python
docker build -t amk-python .
cd ..
cd logstash
docker build -t amk-logstash .

echo "Done"