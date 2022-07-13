#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Join worker nodes to the Kubernetes cluster
echo "[TASK 1] Join node to Kubernetes Cluster"
bash joincluster.sh
echo "[TASK 2] Fix /etc/sysctl.conf file (for calico node)"
bash script-fix-conf.sh
