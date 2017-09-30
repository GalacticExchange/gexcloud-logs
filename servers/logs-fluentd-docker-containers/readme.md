# kibana config_elvis

docker-builder build -s logs-fluentd-docker-containers -c config.elvis.rb

docker-builder up -s logs-fluentd-docker-containers -c config.elvis.rb

# deploy on main

cap main gexcloud:deploy

docker-builder build -s logs-fluentd-docker-containers -c config.main.rb
cap main servers:push_and_deploy_image['logs-fluentd-docker-containers','0.1']
cap main servers:rerun['logs-fluentd-docker-containers','0.1']

