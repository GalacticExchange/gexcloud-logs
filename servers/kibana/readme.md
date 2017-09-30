# kibana config_elvis

docker-builder build -s kibana -c config.elvis.rb

docker-builder up -s kibana -c config.elvis.rb

# deploy on main

cap main gexcloud:deploy

docker-builder build -s kibana -c config.main.rb
cap main servers:push_and_deploy_image['kibana','0.1']
cap main servers:rerun['kibana','0.1']