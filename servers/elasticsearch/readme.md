# overview

* data:
/usr/share/elasticsearch/data

* config
-v "$PWD/esdata":/usr/share/elasticsearch/data elasticsearch


# build





# run

docker run -d --name my-es-1 -p 9200:9200 elasticsearch:2.3.4


* with config

docker run -d -v "$PWD/config":/usr/share/elasticsearch/config elasticsearch

* data
docker run -d -v "$PWD/esdata":/usr/share/elasticsearch/data elasticsearch


* full example

```
docker run -d --name my-elasticsearch \
-p 9200:9200 -p 9300:9300 \
-v "$PWD/server-elasticsearch/data/config":/usr/share/elasticsearch/config \
-v /disk3/data/server-api/elasticsearch/data:/usr/share/elasticsearch/data \
my/elasticsearch


```

cap main servers:rerun['elasticsearch','0.1']
