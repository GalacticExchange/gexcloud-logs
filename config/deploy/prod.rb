set :gex_env, 'prod'

#
#set :rails_env, 'main'
#set :branch, "master"


set :gex_config, {
    prefix: "",
    container_prefix: "gexlogs-",
    service_prefix: '',
    image_prefix: 'gexlogs-',
    dir_servers: "/mount/logs-gexcloud-docker",

    servers_by_hosts: {
        'redis'=>'gex4',
        'elasticsearch'=>'gex4',
        'kibana'=>'gex4',
        'zookeeper'=>'gex4',
        'kafka'=>'gex4',

        'logs-fluentd-servers-kafka-elastic'=>'gex4',

        'logs-fluentd-docker-containers'=>'gex4',
        'logs-fluentd-api-servers'=>'gex3',
        'logs-fluentd-provisioner-servers'=>'gex3',


        'ntopng'=>'gex4',
    }
}

SERVERS={
    'gex1'=>{

    },
    'gex2'=>{
        ip: '172.82.184.106',
        user: 'gex',
        user_pwd: 'ZelenyyKosmonavtgx'
    },
    'gex3'=>{
        ip: '104.247.194.114',
        user: 'gex',
        user_pwd: 'ZelenyyKosmonavtgx'
    },
    'gex4'=>{
        ip: 'gex4.galacticexchange.io',
        user: 'gex',
        user_pwd: 'ZelenyyKosmonavtgx'
    },
}

SERVER_MANAGER = 'gex3'

#
server_name = ENV['server'] || 'manager'
if server_name=='manager'
  server_name = SERVER_MANAGER
end

srv = SERVERS[server_name]
server_ip = srv[:ip]
user = srv[:user]
user_pwd = srv[:user_pwd]

#
role :app, [server_ip]
role :web, [server_ip]
role :db,  [server_ip]
role :host,  [server_ip]


# define host servers
host_servers = {}

SERVERS.each do |name, s|
  h = SSHKit::Host.new({user: s[:user], hostname: s[:ip]})
  h.password = s[:user_pwd]

  host_servers[name] = h
end

set :host_servers, host_servers

#
server server_ip, user: user, roles: %w{srvhost}, primary: true

#
set :deploy_to, "/disk2/gexcloud/#{fetch(:application)}"

set :ssh_options, { forward_agent: true, paranoid: false,  user: user, password: user_pwd}


