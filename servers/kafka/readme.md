# run on main

cap main gexcloud:deploy

docker-builder build -s kafka -c config.main.rb
cap main servers:push_and_deploy_image['kafka','0.1']
cap main servers:rerun['kafka','0.1']