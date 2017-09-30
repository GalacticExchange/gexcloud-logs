# my vars
# load env

require 'json'

$gex_env='dev'


## settings

class ConfigCommon
  GEX_ENV = 'dev'

  ### base settings
  DIR_SERVERS = '/mnt/data/gexcloud-dev/'
  DIR_GEXCLOUD_DATA = '/elvisdata/elvis_docker_storage/'
  DIR_CONTAINERS_DATA = '/elvisdata/elvis_docker_storage/'
  DIR_MOUNT_DATA = '/mount/' # dir on host to mount data


  CONFIG_COMMON={
      'prefix' => "",
      'image_prefix' => 'elvislogs-',
      'container_prefix' => "elvislogs-",
      'service_prefix' => '',
      'dir_data' => DIR_CONTAINERS_DATA,
      'dir_mount_data' => DIR_MOUNT_DATA,
  }


  ### network
  DEFAULT_NETWORK = 'bridge'
  PRIVATE_NETWORK = 'gex_bridge'
  PUB_NETWORK = 'public'
  NETWORK_DEFAULT_GATEWAY = '10.1.0.1'



  SERVERS = {
      'elvis-nginx'=>{
          ip: '51.15.0.101',
          public_ip: '10.1.15.101'
      },

      'mysql'=>{
          ip: '51.0.0.11',
          ports: [[3306, 3306] ],
      },
      'redis'=>{
          ip: '51.15.0.12',
          ports: [[6379, 6379] ],
      },
      'elasticsearch'=>{
          ip: '51.15.0.13',
          public_ip: '10.1.15.13',
          public_gateway: "10.1.0.1",

          ports: [[9200, 9200], [9300, 9300] ],
      },

      'phpmyadmin'=>{
          ip: '51.15.0.14',

          ports: [[8081, 80]]
      },
      'phpredisadmin'=>{
          ip: '51.0.0.15',

          ports: [ [8082,80] ],
      },

      'api'=>{
          ip: '51.0.0.21',
          public_ip: '10.1.12.21',
          ports: [
              [8080,80],
              [8022,22]
          ]
      },

      'rabbit'=>{
          ip: '51.0.0.22',
          public_ip: '10.1.12.22',

          ports: [
              #[5672,5672],
              #[15672,15672],
          ],
      },


      'proxy'=>{
          ip: '51.0.0.31',
          public_ip: '10.1.12.31'
      },
      'webproxy'=>{
          remove_default_bridge: true,
          ip: '51.0.0.32',
          public_ip: '10.1.12.32'
      },
      'openvpn'=>{
          ip: '51.0.0.38',
          public_ip: '10.1.12.38'
      },
      'master'=>{
          ip: '51.0.0.33',
          public_ip: '10.1.12.33'
      },


      'provisioner'=>{
          ip: '51.0.0.55',
          ports: [9022, 22]
      },




      "logs-zookeeper"=>{
          ip: '51.15.0.61',
          ports: [
              #[52181,2181],
          ]
      },
      "logs-kafka"=>{
          ip: '51.0.0.62',
          #public_ip: '10.15.1.62',
          ports: [
              #[KAFKA_PORT_OUT,KAFKA_PORT_OUT],
          ]
      },
      "logs-elasticsearch"=>{
          ip: '51.15.0.63',

          ports: [
              [19200,9200],
              [19300,9300],
          ]
      },
      "logs-flume-kafka-es"=>{
          ip: '51.15.0.64',

          ports: [
              [44455,44455]
          ]
      },
      "logs-flume-nginx-es"=>{
          ip: '51.15.0.67',

          ports: [
              [44465,44465]
          ]
      },
      "logs-flume-rails-es"=>{
          ip: '51.15.0.75',

          ports: [
              [44475,44475]
          ]
      },
      "logs-flume-anginx-rails-es"=>{
          ip: '51.15.0.76',

          ports: [
              [44476,44476]
          ]
      },
      "twitter-flume-kafka"=>{
          ip: '51.15.0.77',

          ports: [
              [44477,44477]
          ]
      },
      "twitter-kafka-flume-es"=>{
          ip: '51.15.0.78',

          ports: [
              [44478,44478]
          ]
      },
      "logs-redis"=>{
          ip: '51.15.0.65',
      },

      # stats, sensu
      'sensu-rabbit'=>{
          ip: '51.0.0.23',
          public_ip: '10.1.12.23',

          ports: [
              # [5671, 5671],
              # [15672, 15672], # rabbitmq management
          ],
      },

      'sensu'=>{
          ip: '51.0.0.24',
          public_ip: '10.1.12.24',

          ports: [
              #[10022,22],
              #[3000, 3000], # uchiwa
              #[4567,4567], # sensu
              # [5671, 5671],
              # [15672, 15672], # rabbitmq management
          ],
      },
      "stats-zookeeper"=>{
          ip: '51.0.0.71',
      },
      "stats-kafka"=>{
          ip: '51.0.0.72',
      },



      "test-tc"=>{
          ip: '51.15.0.90',
          ports: [
              [2022,22],
          ]
      },

      "fluentd-multi"=>{
          ip: '51.15.0.99',
          #ports: [
          #    [2022,22],
          #]
      },

      'fluentd-phpmyadmin-multi'=>{
          ip: '51.15.0.79',

          #ports: [[8082, 81]]
      },

      'fluentd-mysql-multi'=>{
          ip: '51.15.0.80',
          #ports: [[3307, 3307] ],
      },

      'logs-kibana'=>{
          ip: '51.15.0.81',
          #ports: [[3307, 3307] ],
      },
      "logs-fluentd-servers"=>{
          ip: '51.15.0.82',
      },

      "logs-fluentd-docker-containers"=>{
          ip: '51.15.0.84',
      },

      "logs-fluentd-kafka-elastic"=>{
          ip: '51.15.0.83',
      },

      "logs-fluentd-multi"=>{
          ip: '51.15.0.66',
          #ports: [
          #    [2022,22],
          #]
      },

      'logs-fluentd-mysql-multi'=>{
          ip: '51.15.0.68',
          #ports: [[3307, 3307] ],
      },

      "logs-fluentd-servers"=>{
          ip: '51.15.20.3',
      },

  }



  ### swarm
  SWARM_NETWORK = 'net55'

  NODE1 = 'mmxpc'
  SWARM_NODES=[NODE1]
  SWARM_NODE_TEST = NODE1

  NODES_BY_SERVERS = {
      'files' => NODE1,
      'redis' => NODE1,
      'mysql' => NODE1,
      'elasticsearch' => NODE1,
      'phpmyadmin' => NODE1,
      'phpredisadmin' => NODE1,
      'api' => NODE1,

      'master' => NODE1,
      'openvpn' => NODE1,
      'webproxy' => NODE1,
      'proxy' => NODE1,
      'rabbit' => NODE1,
      'sensu' => NODE1,

      'provisioner' => NODE1,
  }


  ###

  MOUNTS = [
      #['51.1.0.50:/disk2/gexcloud-main-data', '/mount/data', 'nfs', 'rw,nolock 0 0']
      ['51.1.0.50:/disk2/gexcloud-main-data', '/mount/data', 'nfs', 'rw,nolock 0 0'],
      ['51.1.0.50:/disk2/gexcloud-main-data/scripts', '/mount/ansible', 'nfs', 'rw,nolock 0 0'],
      ['51.1.0.50:/disk2/gexcloud-main-data/gexcloud', '/mount/vagrant', 'nfs', 'rw,nolock 0 0'],
      ['51.1.0.50:/disk2/gexcloud-main-data/clusters', '/mount/ansibledata', 'nfs', 'rw,nolock 0 0'],
  ]

  HOSTS = [
      ['46.172.71.53', 'git.gex'],
      ['51.0.1.6', 'files.gex'],
  #['51.0.1.8', 'openvpn.gex'],
  #['51.1.0.50', 'master.gex'],
  #['51.0.1.15', 'proxy.gex'],
  #['51.0.1.16', 'webproxy.gex'],
  ]

  HOSTS_BY_SERVERS = {
      'master.gex' => '51.1.0.50',
      'proxy.gex' => '51.1.0.50',
      'openvpn.gex' => '51.1.0.50',
      'webproxy.gex' => '51.1.0.50',
      'provisioner.gex' => '51.1.0.50'
  }

  ###
  SERVER_FILES = '51.0.1.6'

  ### fluentd
  LOG_FLUENTD = "51.15.0.82"

  COOKBOOKS_PATHS = [
      "/projects/chef-repo/cookbooks",
      "/projects/chef-repo/cookbooks-common",
  ]
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