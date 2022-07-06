#!/bin/bash

if [ $# -lt 1 ]; then
    # TODO: print usage
    echo -e "You need to specify a namespace(ns) please \n"
    exit 1
fi

echo "Creating Namespace ${1}..."
kubectl create ns $1
echo -e "Namespace ${1} Created \n"

# echo -e "Creating PV/PVC for logstash ... "
# ##CREO I VOLUMI PER LOGSTASH/PYTHON
# kubectl apply -n $1 -f task-logstash-storage.yaml
# kubectl apply -n $1 -f task-logstash-storage-claim.yaml
# echo -e "PV/PVC for logstash Created \n"
echo -e "Creating PV/PVC for python/kibana ... "
sleep 15
kubectl apply -n $1 -f task-python-storage.yaml
kubectl apply -n $1 -f task-python-storage-claim.yaml
echo -e "PV/PVC for python/kibana Created "
echo -e "PV/PVC Created \n"
sleep 15

echo -e "Creating services..."
##CREAIAMO PRIMA I SERVIZI
##ZOOKEEPER
kubectl apply  -n $1 -f zookeeper-service.yaml
##KAFKA
kubectl apply  -n $1 -f kafka-server-service.yaml
##LOGSTASH
kubectl apply  -n $1 -f logstash-service.yaml
##ELASTIC
kubectl apply  -n $1 -f elastic-search-service.yaml
##KIBANA
kubectl apply  -n $1 -f kibana-service.yaml

echo -e " Services Created \n"
sleep 5

###PYTHON GET FOTO PROBLEM??

echo "Creating Deployment..."
###ORA I DEPLOYMENT
kubectl apply  -n $1 -f zookeeper-deployment.yaml
##KAFKA
kubectl apply  -n $1 -f kafka-server-deployment.yaml
##LOGSTASH
kubectl apply  -n $1 -f logstash-deployment.yaml
##PYTHON
kubectl apply  -n $1 -f python-deployment.yaml
##ELASTIC
kubectl apply  -n $1 -f elastic-search-deployment.yaml
##KIBANA
kubectl apply  -n $1 -f kibana-deployment.yaml
##SPARK
kubectl apply  -n $1 -f spark-deployment.yaml

echo -e "Deployment Created \n"