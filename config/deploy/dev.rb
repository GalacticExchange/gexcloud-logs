set :gex_env, 'dev'

set :gex_config, {
    prefix: "",
    container_prefix: "gex-",
    service_prefix: '',
    image_prefix: 'gex-',
    dir_servers: "/mnt/data/gexcloud-dev",

}

set :user, 'mmx'

SERVERS={
    'mmxpc'=>{
        ip: '10.1.0.12',
        user: 'mmx',
        user_pwd: 'PH_GEX_PASSWD1'
    },
}

SERVER_MANAGER = 'mmxpc'

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

#
role :app, [server_ip]
role :web, [server_ip]
role :db,  [server_ip]
role :host,  [server_ip]


#
#set :rails_env, 'main'
#set :branch, "master"

server server_ip, user: user, roles: %w{web}, primary: true
set :deploy_to, "/disk2/vagrant/#{fetch(:application)}"

set :ssh_options, { forward_agent: true, paranoid: false,  user: user, password: user_pwd}
#set :ssh_options, { forward_agent: true, user: 'uadmin', password: 'PH_GEX_PASSWD1'}
#set :ssh_options, { user: 'uadmin', password: 'PH_GEX_PASSWD1'}
