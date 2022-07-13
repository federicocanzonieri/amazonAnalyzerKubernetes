#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

POD_NETWORK=192.168.0.0/16
SERVICE_NETWORK=172.42.0.0/16
MASTER_IP=$(hostname -I | cut -d' ' -f1)

# echo $MASTER_IP
# echo $SERVICE_NETWORK
# echo $POD_NETWORK

# exit 0

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm config images pull
kubeadm init --apiserver-advertise-address=$MASTER_IP --pod-network-cidr=$POD_NETWORK  --service-cidr=$SERVICE_NETWORK |& tee /root/kubeinit.log 
# kubeadm init --apiserver-advertise-address=10.0.0.5 --pod-network-cidr=192.168.0.0/16  --service-cidr=172.42.0.0/16 |& tee /root/kubeinit.log 

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/$USER/.kube
cp /etc/kubernetes/admin.conf /home/$USER/.kube/config
chown -R $USER:$USER /home/$USER/.kube

# Deploy flannel network
echo "[TASK 3] Deploy Calico network"
su - $USER -c "kubectl create -f $(pwd)/calico.yaml"

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to joincluster.sh"
kubeadm token create --print-join-command > joincluster.sh
