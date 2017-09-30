# kibana config_elvis

docker-builder build -s logs-fluentd-api-servers -c config.elvis.rb

docker-builder up -s logs-fluentd-api-servers -c config.elvis.rb

# deploy on main

cap main gexcloud:deploy

docker-builder build -s logs-fluentd-api-servers -c config.main.rb
cap main servers:push_and_deploy_image['logs-fluentd-api-servers','0.1']
cap main servers:rerun['logs-fluentd-api-servers','0.1']

