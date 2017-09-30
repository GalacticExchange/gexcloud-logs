add_config({
    'build' => {
        'build_type' => 'Dockerfile',
        "image_name" => "logs-fluentd-servers-kafka-elastic",

    },

    'provision' => {
        #"host" => {    'script_type' => 'chef_recipe',     'script' => 'install_host',  },
        #"node" => {    'script_type' => 'chef_recipe',     'script' => 'install',  }
    },


    'docker' => {
        "command"=> '/etc/bootstrap',  #'fluentd -c /fluentd/etc/fluent.conf',

        'volumes' => [
            #['/elvisdata/elvis_docker_storage/elvis-nginx/var/log/nginx/', '/elvis-nginx-logs/']
        ],
        'links' => [
        ],
        'run_env'=>[
            ['FLUENTD', 'fluentd'],
            ['FLUENTD_CONF_DIR', '/fluentd/etc'],
            ['FLUENTD_CONF', '/fluent.conf'],
        ],

        'hosts'=>ConfigLib::build_hosts(['elasticsearch', 'kafka'], true),
    },

    'attributes' => {

    }
})
