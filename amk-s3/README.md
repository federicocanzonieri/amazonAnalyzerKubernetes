# amazonAnalyzerKubernetes
# amk-s3


## Description

- This is a project created for the subject of Cloud System  at UniCT.
- It creates a complete stream data pipeline to take reviews of a product from Amazon e then perfom some sentiment analysis using K8S(Kubernetes) and some AWS services like S3, Amazon Opensearch Service and Grafana.



### Start

This project required **K8S cluster** and **AWS account**
To configure a K8S cluster you can see the *k8s_ubuntu_vagrant*.
- Download
  ```bash
  git clone https://github.com/federicocanzonieri/amazonAnalyzerKubernetes.git
  cd amazonAnalyzerKubernetes
  ```

### AMK-S3-OPENSEARCH-LAMBDA
#### Architecture
![Alt text](images/arch-s3-lambda-opensearch.png "Architecture s3-lambda-opensearch")

The folder *amk-s3* use  kubernetes pods/services locally and some AWS services (S3,Lambda, Amazon Open Search Service, Grafana).
Before starting the application make sure to configure the **.env** and **.env-aws-credentials** files on *python-deployment.yaml* (see after).
After that you can use to start:
- Start:
  ```bash
  cd amk-s3
  ./run-s3-lambda-opensearch.sh <NAMESPACE>
  ```
You can use to stop:
- Stop:
  ```bash
  ./delete.sh <NAMESPACE>
  ```
Make sure to configure **.env** properly before use it (**CODE\_PRODUCT**, **START\_PAGE**,**END\_PAGE**,...) and configure **.env-aws-credentials** (**AWS_ACCESS_KEY_ID**,**AWS_SECRET_ACCESS_KEY**,**BUCKET_NAME**,**BUCKET_OUTPUT**).
You can see the result using *opensearch* dashboard (you should have the URL).

#### Lambda function configuration

The lambda.zip contains all the configuration, create a lambda function and upload the *zip* file, add a trigger from *S3* from the BUCKET_OUTPUT, trigger method PUT, filter by *.json* files only, add the environment variable *aws_access_key_id*, *aws_secret_access_key* (in lower case)  in the lambda editor. Add the permission for S3 read and Elastic Search operations.




### AMK-S3-OPENSEARCH
#### Architecture
![Alt text](images/arch-s3-opensearch.png "Architecture s3-opensearch")

The folder *amk-s3* use  kubernetes pods/services locally and some AWS services (S3, Amazon Open Search Service, Grafana).
Before starting the application make sure to configure the **.env** and **.env-aws-credentials** files on *python-deployment.yaml* (see after).
After that you can use to start:
- Start:
  ```bash
  cd amk-classic
  ./run-s3-opensearch.sh <NAMESPACE>
  ```
You can use to stop:
- Stop:
  ```bash
  ./delete.sh <NAMESPACE>
  ```
Make sure to configure **.env** properly before use it (**CODE\_PRODUCT**, **START\_PAGE**,**END\_PAGE**,...) and configure **.env-aws-credentials** (**AWS_ACCESS_KEY_ID**,**AWS_SECRET_ACCESS_KEY**,**BUCKET_NAME**,**BUCKET_OUTPUT**,**REGION_BUCKET**,**INDEX_OPENSEARCH**,**USER_OPENSEARCH**,**PASSWORD_OPENSEARCH**,**DOMAIN_URL_OPENSEARCH**)   .
You can see the result using *opensearch* dashboard (you should have the URL).




#### Images Docker

The app uses the docker images present on the *docker hub*, you can build your own Docker images at */docker-images*. You can modify and check the code before build it.
- Build:
  ```bash
   ./build-s3-opensearch.sh
  ```
  
### AMK-S3
#### Architecture
![Alt text](images/arch-s3.png "Architecture s3")

The folder *amk-s3* use  kubernetes pods/services locally and some AWS services (S3).
Before starting the application make sure to configure the **.env** and **.env-aws-credentials** files on *python-deployment.yaml* (see after).
After that you can use to start:
- Start:
  ```bash
  cd amk-s3
  ./run-s3.sh <NAMESPACE>
  ```
You can use to stop:
- Stop:
  ```bash
  ./delete.sh <NAMESPACE>
  ```
Make sure to configure **.env** properly before use it (**CODE\_PRODUCT**, **START\_PAGE**,**END\_PAGE**,...) and configure **.env-aws-credentials** (**AWS_ACCESS_KEY_ID**,**AWS_SECRET_ACCESS_KEY**,**BUCKET_NAME**)   .
You can see the result using *kibana* dashboard, it exposes a service with a **Nodeport(30008)**, so you can access the dashboard at this address **<IP_WORKER_KIBANA>:30008**, or if you don't have a public ip for worker you can use (configure the *ip_private_master* in the script below)
- Port-forward:
  ```bash
  ./port-forward.sh <NAMESPACE> <POD> <PORT_POD>
  ```
it will open a port-forward with the ip of the master, now you can visualize kibana ad **<IP_MASTER>:5601**.



#### Images Docker

The app uses the docker images present on the *docker hub*, you can build your own Docker images at */docker-images*. You can modify and check the code before build it.
- Build:
  ```bash
   ./build-s3.sh
  ```
  
## Configuration

To modify configuration see **python-deployment.yaml** and **.env** file.

| Variable| Description |Default value|
| :-: | :-: |:-:|
|CODE_PRODUCT| Code of the product to analyze (default ...) | ... |
|TIMEOUT_FETCH_ANOTHER_PAGE|Time (second) to wait before fetch another page | 5 |
|START_PAGE |Page start reviews |0 |
|END_PAGE|Page end reviews | 6 |
|DOMAIN_URL| Domain for fetch pages (www.amazon.) | supported co.uk,it  |
|MODE_REVIEWS| "recent" or "useful" | "recent"  |

To modify configuration for AWS see **.env-aws-credentials** file.

| Variable| Description |Default value|
| :-: | :-: |:-:|
|AWS\_ACCESS\_KEY\_ID| AWS ACCESS KEY |  |
|AWS\_SECRET\_ACCESS\_KEY| AWS SECRET ACCESS KEY |  |
|BUCKET\_NAME |Bucket for storing original data | |
|NAME\_FILES\_S3|Prefix for files in bucket BUCKET_NAME  |  |
|BUCKET_OUTPUT| Bucket for storing processed data |   |
|REGION\_BUCKET| Region of bucket BUCKET_OUTPUT |   |
|INDEX_OPENSEARCH| Name of index to store on opensearch |   |
|USER_OPENSEARCH| User opensearch |   |
|PASSWORD_OPENSEARCH| Password opensearch |   |
|DOMAIN_URL_OPENSEARCH| Domain url opensearch |   |


## Notes
Make sure that you have all the containers up after 2-3 min after launching the "run-s3-*.sh".
