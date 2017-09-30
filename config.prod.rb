# my vars
# load env

require 'json'

$gex_env='prod'

## settings
class ConfigCommon
  GEX_ENV = $gex_env

  ### base settings
  DIR_SERVERS = '/disk2/gexcloud-data/logs-gexcloud-docker/'
  #DIR_GEXCLOUD_DATA = '/disk2/gexcloud-data/'
  DIR_CONTAINERS_DATA = '/disk2/data/containers-logs-gexcloud/'



  CONFIG_COMMON={
      'prefix' => "",
      'image_prefix' => 'gexlogs-',
      'container_prefix' => "gexlogs-",
      'service_prefix' => '',
      'dir_data' => DIR_CONTAINERS_DATA,

  }


  ### networks
  DEFAULT_NETWORK = 'bridge'
  PRIVATE_NETWORK = 'overlay'
  PUB_NETWORK = 'public'
  NETWORK_DEFAULT_GATEWAY = '51.1.1.100'




  SERVERS = {
      'redis'=>{
          ip: '51.0.20.1',
      },

      'ntopng'=>{
          ip: '51.0.20.2',
          ports: [
              #[8080,80],
              #[8022,22]
          ]
      },

      "logs-fluentd-api-servers"=>{
          ip: '51.0.20.3',
      },

      "logs-fluentd-docker-containers"=>{
          ip: '51.0.20.4',
          ports: [
              [24226, 24226],
          ]
      },

      "logs-fluentd-servers-kafka-elastic"=>{
          ip: '51.0.20.5',

      },

      "logs-fluentd-provisioner-servers"=>{
          ip: '51.0.20.10',
      },

      "elasticsearch"=>{
          ip: '51.0.20.6',
      },

      'kibana'=>{
          ip: '51.0.20.7',
      },

      'zookeeper'=>{
          ip: '51.0.20.8',
      },

      'kafka'=>{
          ip: '51.0.20.9',
      },


  }



  ###
  MOUNTS = [

  ]

  HOSTS = [
      ['46.172.71.53', 'git.gex'],
      #['51.0.1.6', 'files.gex'],

  ]

  HOSTS_BY_SERVERS = {
  }

  ###
  COOKBOOKS_PATHS = [
      "/projects/chef-repo/cookbooks",
      "/projects/chef-repo/cookbooks-common",
  ]

  OFFICE_IPS = "46.172.71.50, 46.172.71.53, 46.172.71.54, 10., 127., 51., 172.82."

  ###
  DIR_GEXCLOUD_CONTAINERS_DATA = '/disk2/data/containers/gex-prod/'


end

#
$config_common = {}
ConfigCommon.constants.each do |c|
  $config_common[c] = ConfigCommon.const_get(c)
end

#
require_relative "config_lib.rb"


##########
dir_data ConfigCommon::CONFIG_COMMON['dir_data']
prefix ConfigCommon::CONFIG_COMMON['prefix']
image_prefix ConfigCommon::CONFIG_COMMON['image_prefix']
container_prefix ConfigCommon::CONFIG_COMMON['container_prefix']
service_prefix ConfigCommon::CONFIG_COMMON['service_prefix']

a_servers = ConfigLib.build_servers_config



a_servers.each do |name, srv|

  # fixes
  server name do |s|
    s.build = srv['build']
    s.provision = srv['provision']
    s.docker = srv['docker']
    s.attributes = srv['attributes']
  end
end

