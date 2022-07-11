# amazonAnalyzerKubernetes
# amk-classic


## Description

- This is a project created for the subject of Cloud System  at UniCT.
- It creates a complete stream data pipeline to take reviews of a product from Amazon e then perfom some sentiment analysis using K8S(Kubernetes) and some AWS services like S3, Amazon Opensearch Service and Grafana.



## Start

This project required **K8S cluster** and **AWS account**
To configure a K8S cluster you can see the *k8s_ubuntu_vagrant*.
- Download
  ```bash
  git clone https://github.com/federicocanzonieri/amazonAnalyzerKubernetes.git
  cd amazonAnalyzerKubernetes
  ```
### AMK-Classic
The folder *amk-classic* use only kubernetes pods/services locally, it doesn't use any AWS services. 
Before starting the application make sure to configure the **.env** file on *python-deployment.yaml* (see after).
After that you can use to start:
- Start:
  ```bash
  cd amk-classic
  ./run.sh <NAMESPACE>
  ```
You can use to stop:
- Stop:
  ```bash
  ./delete.sh <NAMESPACE>
  ```
Make sure to configure **.env** properly before use it (**CODE\_PRODUCT**, **START\_PAGE**,**END\_PAGE**,...).
You can see the result using *kibana* dashboard, it exposes a service with a **Nodeport(30008)**, so you can access the dashboard at this address **<IP_WORKER_KIBANA>:30008**, or if you don't have a public ip for worker you can use (configure the *ip_private_master* in the script below)
- Port-forward:
  ```bash
  ./port-forward.sh <NAMESPACE> <POD> <PORT_POD>
  ```
it will open a port-forward with the ip of the master, now you can visualize kibana ad **<IP_MASTER>:5601**.


## Configuration

To modify configuration see **python-deployment.yaml** file.

| Variable| Description |Default value|
| :-: | :-: |:-:|
|CODE_PRODUCT| Code of the product to analyze (default ...) | ... |
|TIMEOUT_FETCH_ANOTHER_PAGE|Time (second) to wait before fetch another page | 5 |
|START_PAGE |Page start reviews |0 |
|END_PAGE|Page end reviews | 6 |
|DOMAIN_URL| Domain for fetch pages (www.amazon.) | supported co.uk,it  |
|MODE_REVIEWS| "recent" or "useful" | "recent"  |


## Images Docker

The app uses the docker images present on the *docker hub*, you can build your own Docker images at */docker-images*. You can modify and check the code before build it.

## Network

Here is the table of services and network configuration.

| Service|Port |
| :-: |:-:|  
|Logstash |**6000/6001**
|Zookeeper|**2181**
|KafkaServers   |**9092**
|ElasticSearch   |**9200/9300**
|Kibana  |**5601**


## Notes
Make sure that you have all the containers up after 2-3 min after launching the "run.sh".
