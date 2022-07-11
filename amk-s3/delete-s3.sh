#!/bin/bash

if [ $# -lt 1 ]; then
    # TODO: print usage
    echo -e "You need to specify a namespace(ns) please \n"
    exit 1
fi
echo "Deleting namespace(ns) ${1}..."
kubectl delete ns $1
echo -e "Namespace(ns) ${1} deleted \n"

echo "Deleting namespace(ns) ${1}..."
kubectl delete secret 
echo -e "Namespace(ns) ${1} deleted \n"


echo "Persisten Volume (pv) task-python-storage..."
kubectl delete pv task-python-storage
echo -e "Persisten Volume (pv) task-python-storage deleted \n"
