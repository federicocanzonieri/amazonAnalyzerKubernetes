#!/bin/bash

echo $0
echo $1

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


##CREO I VOLUMI PER LOGSTASH/PYTHON
kubectl apply -n $1 -f task-logstash-storage.yaml
kubectl apply -n $1 -f task-logstash-storage-claim.yaml
kubectl apply -n $1 -f task-python-storage.yaml
kubectl apply -n $1 -f task-python-storage-claim.yaml


##READWRITEONCE OK READWRITEMANY NOT OK NOT BOUND?WHY
###PYTHON GET FOTO PROBLEM??
###PRENDERE GLI IP DI KAFKA_SERVER E ZOOKEEPER E METTERLI SU SERVER.PROPERTIES PRIMA DI CREARE L'IMMAGINE 


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



