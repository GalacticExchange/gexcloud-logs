# Deploy

cap main gexcloud:deploy
 
 
# Run on main server

```
cap main servers:start['elasticsearch','0.1']
cap main servers:start['zookeeper','0.1']
cap main servers:start['kafka','0.1']
cap main servers:start['kibana','0.1']

cap main servers:start['logs-fluentd-docker-containers','0.1']
cap main servers:start['logs-fluentd-servers-kafka-elastic','0.1']

cap main servers:start['logs-fluentd-api-servers','0.1']
cap main servers:start['logs-fluentd-provisioner-servers','0.1']

```
