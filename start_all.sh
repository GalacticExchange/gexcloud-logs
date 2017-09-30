#!/bin/bash

# input:
# $env
# example:
# ./start_all.sh main


gex_env=$1
config="config.$gex_env.rb"

#
#source env.$api_server_env.sh



docker-builder start -s elasticsearch -c $config
docker-builder start -s zookeeper -c $config
docker-builder start -s kafka -c $config
docker-builder start -s kibana -c $config


docker-builder start -s logs-fluentd-docker-containers -c $config
docker-builder start -s logs-fluentd-servers-kafka-elastic -c $config
docker-builder start -s logs-fluentd-api-servers -c $config
docker-builder start -s logs-fluentd-provisioner-servers -c $config
