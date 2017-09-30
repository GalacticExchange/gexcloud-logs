# kibana config_elvis

docker-builder build -s logs-fluentd-servers-kafka-elastic -c config.elvis.rb

docker-builder up -s logs-fluentd-servers-kafka-elastic -c config.elvis.rb

# deploy on main

server=manager cap main gexcloud:copy_config_files
server=manager cap main gexcloud:deploy

docker-builder build -s logs-fluentd-servers-kafka-elastic -c config.main.rb
cap main servers:push_and_deploy_image['logs-fluentd-servers-kafka-elastic','0.1']
cap main servers:rerun['logs-fluentd-servers-kafka-elastic','0.1']