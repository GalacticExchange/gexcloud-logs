set :gex_env, 'aws'

set :gex_config, {
    prefix: "",
    container_prefix: "gexlogs-",
    service_prefix: '',
    image_prefix: 'gexlogs-',
    dir_servers: "/disk2/servers-gexcloud-logs",

    servers_by_hosts: {
        'redis'=>'gexsrv',
        'elasticsearch'=>'gexsrv',
        'kibana'=>'gexsrv',
        'zookeeper'=>'gexsrv',
        'kafka'=>'gexsrv',

        'logs-fluentd-docker-containers'=>'gexsrv',
        'logs-fluentd-api-servers'=>'gexsrv',
        'logs-fluentd-provisioner-servers'=>'gexsrv',
        'logs-fluentd-servers-kafka-elastic'=>'gexsrv',

        'ntopng'=>'gexsrv',



  }
}

set :user, 'gex'

SERVERS={
    'gexsrv'=>{ip: '52.65.97.4', user: 'gex', user_pwd:'PH_GEX_PASSWD1'},
    #'testsrv'=>{ip: 'gex2.devgex.net',user: 'gex',user_pwd: 'PH_GEX_PASSWD1'},
}

SERVER_MANAGER = 'gexsrv'

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
  h = SSHKit::Host.new({
                           user: s[:user],
                           hostname: s[:ip],
                           #port: ssh_port
                       })
  h.password = s[:user_pwd]

  host_servers[name] = h
end

set :host_servers, host_servers

# main host server
server server_ip, user: user, roles: %w{srvhost}, primary: true

#
set :ssh_options, { forward_agent: true, paranoid: false,  user: user, password: user_pwd}
#set :ssh_options, { forward_agent: true, user: 'uadmin', password: 'PH_GEX_PASSWD1'}
#set :ssh_options, { user: 'uadmin', password: 'PH_GEX_PASSWD1'}



#
#set :deploy_to, "/disk2/vagrant/#{fetch(:application)}"




