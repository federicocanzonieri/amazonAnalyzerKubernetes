# Setup a cluster k8s



## Description

- Create a k8s cluster.

### Start

To configure a K8S cluster you can see the *k8s_ubuntu_vagrant*.
  ```bash
  git clone https://github.com/federicocanzonieri/amazonAnalyzerKubernetes.git
  cd amazonAnalyzerKubernetes/k8s_ubuntu_vagrant
  ```
### Master 
To configure the master you can use (on the master node):

  ```bash
  sudo ./bootstrap.sh
  sudo ./boostrap_kmaster.sh
  sudo ./script-fix.sh
   ```

After that the master is now configured, you should see something similar.
 ```bash
  kubectl get nodes
  NAME      STATUS   ROLES    AGE     VERSION
  kmaster   Ready    master   3m41s   v1.19.9
   ```
```bash
  kubectl get pod -A
  NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
  kube-system   calico-kube-controllers-56b44cd6d5-tq4mm   1/1     Running   0          3m54s
  kube-system   calico-node-n49cp                          1/1     Running   1          3m54s
  kube-system   coredns-f9fd979d6-6rm64                    1/1     Running   0          3m54s
  kube-system   coredns-f9fd979d6-krjh9                    1/1     Running   0          3m54s
  kube-system   etcd-kmaster                               1/1     Running   0          4m13s
  kube-system   kube-apiserver-kmaster                     1/1     Running   0          4m13s
  kube-system   kube-controller-manager-kmaster            1/1     Running   0          4m13s
  kube-system   kube-proxy-bmlsc                           1/1     Running   0          3m54s
  kube-system   kube-scheduler-kmaster                     1/1     Running   0          4m13s
   ```


### Workers
Now we can configure the workers, on the master node use the *send-workers-setup.sh <IP_WORKER>*, to send all the configuration files needed. This require that the master is able to connect via ssh to the worker.
  ```bash
    On the master node
   ./send-workers-setup.sh 192.168.4.113
    [TASK 1] Copy files to workers, Ip worker:192.168.4.113 
    
    bootstrap.sh                                             100% 2471     1.0MB/s   00:00    
    bootstrap_kmaster.sh                                     100% 1172     1.6MB/s   00:00    
    bootstrap_kworker.sh                                     100%  250   321.2KB/s   00:00    
    generate_token.sh                                        100%   63    83.4KB/s   00:00    
    joincluster.sh                                           100%  172   253.7KB/s   00:00    
    script-fix-conf.sh                                       100%  334   397.1KB/s   00:00    
    send-workers-setup.sh                                    100%   83   104.9KB/s   00:00  
  ```
    
  ```bash
Now on the worker node
   sudo ./bootstrap.sh
   sudo ./bootstrap_kworker.sh  
   ```

On master node check everythings is fine
  ```bash
    kubectl get pod -A
    NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
    kube-system   calico-kube-controllers-56b44cd6d5-tq4mm   1/1     Running   0          22m
    kube-system   calico-node-774mg                          1/1     Running   0          66s
    kube-system   calico-node-n49cp                          1/1     Running   1          22m
    kube-system   coredns-f9fd979d6-6rm64                    1/1     Running   0          22m
    kube-system   coredns-f9fd979d6-krjh9                    1/1     Running   0          22m
    kube-system   etcd-kmaster                               1/1     Running   0          22m
    kube-system   kube-apiserver-kmaster                     1/1     Running   0          22m
    kube-system   kube-controller-manager-kmaster            1/1     Running   0          22m
    kube-system   kube-proxy-bmlsc                           1/1     Running   0          22m
    kube-system   kube-proxy-xn9hm                           1/1     Running   0          66s
    kube-system   kube-scheduler-kmaster                     1/1     Running   0          22m
   ```

### Generate a new token
You can generate another token to join the cluster using 
   ```bash
     ./generate_token.sh
   ```

### Common problems
Make sure that you have all the *kube-system* pods up after 5 minutes after the launching of the cluster, check carefully the *calico-node* and the *coredns*.
Before executing it, check the first line and adjust the interface (eth0,ens3,..)
  ```bash
     ./script-calico-coredns-fix.sh
   ```






