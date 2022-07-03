#!/bin/bash

echo $0
echo $1

##ELASTIC
kubectl apply  -n $1 -f elastic-search-service.yaml
##KIBANA
kubectl apply  -n $1 -f kibana-service.yaml


kubectl apply -n $1 -f task-python-storage.yaml
kubectl apply -n $1 -f task-python-storage-claim.yaml


##READWRITEONCE OK READWRITEMANY NOT OK NOT BOUND?WHY
###PYTHON GET FOTO PROBLEM??

###ORA I DEPLOYMENT
##PYTHON
kubectl apply  -n $1 -f python-deployment-s3.yaml
##ELASTIC
kubectl apply  -n $1 -f elastic-search-deployment.yaml
##KIBANA
kubectl apply  -n $1 -f kibana-deployment.yaml



