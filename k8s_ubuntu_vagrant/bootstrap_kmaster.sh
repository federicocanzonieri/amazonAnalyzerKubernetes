#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm config images pull
kubeadm init --apiserver-advertise-address=10.0.0.4 --pod-network-cidr=192.168.0.0/16  --service-cidr=172.42.0.0/16 |& tee /root/kubeinit.log 

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/azureuser/.kube
cp /etc/kubernetes/admin.conf /home/azureuser/.kube/config
chown -R azureuser:azureuser /home/azureuser/.kube

# Deploy flannel network
echo "[TASK 3] Deploy Calico network"
su - azureuser -c "kubectl create -f /home/azureuser/k8s_ubuntu_vagrant/calico.yaml"

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to joincluster.sh"
kubeadm token create --print-join-command > joincluster.sh
