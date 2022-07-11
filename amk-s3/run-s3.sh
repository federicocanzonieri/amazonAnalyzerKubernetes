#!/bin/bash

if [ $# -lt 1 ]; then
    # TODO: print usage
    echo -e"You need to specify a namespace(ns) please \n"
    exit 1
fi

echo "Creating Namespace ${1}..."
kubectl create ns $1
echo -e "Namespace ${1} Created \n"

echo "Creating PV/PVC"
kubectl apply -n $1 -f task-python-storage.yaml
kubectl apply -n $1 -f task-python-storage-claim.yaml
echo -e "PV/PVC Created \n"
sleep 10

echo "Creating Secrets"
kubectl create secret generic -n $1 --from-env-file=.env-aws-credentials my-aws-credentials 
kubectl create secret generic -n $1 --from-env-file=.env python-configuration 
echo -e "Secrets Created \n"

echo "Creating Services..."
##ELASTIC
kubectl apply  -n $1 -f elastic-search-service.yaml
##KIBANA
kubectl apply  -n $1 -f kibana-service.yaml
##GRAFANA
kubectl apply  -n $1 -f grafana-service.yaml

echo -e "Services Created \n"
sleep 5

##READWRITEONCE OK READWRITEMANY NOT OK NOT BOUND?WHY
###PYTHON GET FOTO PROBLEM??

###ORA I DEPLOYMENT
##PYTHON
echo "Creating Deployment..."
kubectl apply  -n $1 -f python-deployment-s3.yaml
##GRAFANA
kubectl apply  -n $1 -f grafana-deployment.yaml
##ELASTIC
kubectl apply  -n $1 -f elastic-search-deployment.yaml
##KIBANA
kubectl apply  -n $1 -f kibana-deployment.yaml
##SPARK
kubectl apply  -n $1 -f spark-deployment-s3.yaml
echo -e "Deployment Created\n"
