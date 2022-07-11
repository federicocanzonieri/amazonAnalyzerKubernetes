from pyspark.sql import SparkSession
from pyspark.conf import SparkConf
from pyspark import SparkContext
from pyspark.sql.functions import from_json, col, to_timestamp, unix_timestamp, window
from pyspark.sql.types import *
from elasticsearch import Elasticsearch
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
import time
import socket
import os
from pyspark.sql.functions import udf
from translate import Translator


translator= Translator(to_lang="en")##from italian

HOST_ELASTIC=os.getenv("ELASTIC_SEARCH_SERVICE_HOST")
PORT_ELASTIC=os.getenv("PORT_ELASTIC_1")
TOPIC=os.getenv("TOPIC")
INDEX=os.getenv("INDEX")
vader=SentimentIntensityAnalyzer()

##ESTABLISH CONNECTION TO LOGSTASH
time.sleep(int(os.getenv("TIMEOUT_BEFORE_START_SPARK")))


##GET POLARITY
def get_sentiment(text):

    value = vader.polarity_scores(translator.translate(text))
    value = value['compound']
    return value

##SCHEMA JSON (FROM KAFKA)
schema = StructType([
    StructField("date", StringType(), False),
    StructField("body", StringType(), False),
    StructField("title", StringType(), False),
    StructField("rating", StringType(), False),
    StructField("name", StringType(), False),
    StructField("verified_buy", StringType(), False),
    StructField("helpful_vote", StringType(), False),
    StructField("country", StringType(), False),
    #StructField("rating", LongType(), False),
])

def get_spark_session(host_elastic):
    spark_conf = SparkConf()\
        .set('es.nodes', host_elastic)\
        .set('es.port', '9200')
    sc = SparkContext(appName='reviews_analyzer')
    return SparkSession(sc)



spark = get_spark_session("place")
spark.sparkContext.setLogLevel("ERROR")

# hadoop_conf = spark._jsc.hadoopConfiguration()
# hadoop_conf.set("fs.s3n.impl", "org.apache.hadoop.fs.s3native.NativeS3FileSystem")
# # hadoop_conf.set("fs.s3a.awsAccessKeyId", "TEMPLEAT")
# # hadoop_conf.set("fs.s3a.awsSecretAccessKey", "eeer")

BUCKET_NAME=str(os.getenv("BUCKET_NAME"))
BUCKET_OUTPUT=str(os.getenv("BUCKET_OUTPUT"))
topic=TOPIC
elastic_host =  HOST_ELASTIC+":9200"
elastic_index = INDEX
kafkaServer = str(os.getenv("KAFKA_SERVER_SERVICE_HOST"))+":9092"

# print("nuovo")

# df=spark.readStream \
#         .format('kafka') \
#         .option('kafka.bootstrap.servers', kafkaServer) \
#         .option('subscribe', topic) \
#         .option("startingOffsets","earliest") \
#         .load() \
#         #
#         #.load() \
#         #.option("kafka.group.id", "spark-consumer") \

df = spark.readStream\
              .schema(schema)\
              .json("s3a://"+str(BUCKET_NAME)+"/")
              #.load()



####ELASTIC_SEARCH
es_mapping = {
    "mappings": {
        "properties": {
            "@timestamp":       {"type": "date", "format": "epoch_second"},
            "rating":   {"type": "integer"},
            "title":    {"type": "keyword"},
            "body":     {"type": "keyword"},
            "date":     {"type": "date","format":"yyyy-MM-dd"},
            "name": {"type":"keyword"},
            "verified_buy" :{"type":"keyword"},
            "helpful_vote": {"type": "integer"},
            "country":{"type":"keyword"},
            "sentiment":{"type":"double"}
        }
    }
}

print(elastic_host)
es = Elasticsearch(hosts='http://'+str(elastic_host))
response = es.indices.create(
    index=elastic_index,
    body=es_mapping,
    ignore=400
)

if 'acknowledged' in response:
    if response['acknowledged'] == True:
        print("Successfully created index:", response['index'])


###SOLO CON KAFKA
##Con solo cast as string funziona
# df=df.selectExpr("CAST(value as STRING)") \
#     .select(from_json("value",schema=schema).alias("data"))\
#     .select("data.*") \
#       #.alias("data"))\
#      #\

def splitting(x):
    return x.split(" ")

sentimen=udf(get_sentiment,DoubleType())
splitt=udf(splitting,ArrayType(StringType()))
df=df.withColumn("sentiment",sentimen("title"))
df=df.withColumn("words",splitt("title"))


# df.writeStream\
#   .format("json")\
#   .option("checkpointLocation", "./checkpoints") \
#   .option("path", "s3a://"+BUCKET_OUTPUT +"/")\
#   .start()\
#   .awaitTermination()


##ELASTICSEARCH LOCAL OUTPUT
query=df.writeStream \
        .option("checkpointLocation", "./checkpoints") \
        .format("es") \
        .start(elastic_index + "/_doc")\
        .awaitTermination()

###S3 BUCKET OUTPUT




