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
docker-compose build
echo "Done"