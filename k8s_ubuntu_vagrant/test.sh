echo "[TASK 3] Deploy Calico network"
su - azureuser -c "kubectl create -f $(pwd)/calico.yaml"
