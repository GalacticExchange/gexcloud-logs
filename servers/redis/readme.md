# overview
* https://hub.docker.com/_/redis/

# build

docker build -t my/redis .


# run

docker run -d --name my-redis -p 6379:6379 my/redis


* full example
```
docker run -d --name my-redis -p 6379:6379  \
-v /disk3/data/server-api/redis/data:/data \
redis:3.2.4 --appendonly yes

```
