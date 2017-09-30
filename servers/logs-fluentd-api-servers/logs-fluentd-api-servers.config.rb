dir_api_data = $config_common[:DIR_GEXCLOUD_CONTAINERS_DATA]+"api/"

add_config({
    'build' => {
        'build_type' => 'Dockerfile',
        "image_name" => "logs-fluentd-api-servers",

    },

    'provision' => {
        #"host" => {    'script_type' => 'chef_recipe',     'script' => 'install_host',  },
        #"node" => {    'script_type' => 'chef_recipe',     'script' => 'install',  }
    },


    'docker' => {
        "command"=> '/etc/bootstrap',  #'fluentd -c /fluentd/etc/fluent.conf',

        'volumes' => [
            # for elvis
            #['/elvisdata/elvis_docker_storage/elvis-nginx/var/log/nginx/', '/nginx/']
            # for main
            ["#{dir_api_data}log/nginx", '/api-nginx/'],
            ["#{dir_api_data}log/passenger", '/api-passenger/'],
            ["#{dir_api_data}log/god", '/api-god/'],
            ["#{dir_api_data}apps/apihub/shared/log", '/api-apihub/'],

        ],
        'links' => [
        ],
        'run_env'=>[
            ['FLUENTD', 'fluentd'],
            ['FLUENTD_CONF_DIR', '/fluentd/etc'],
            ['FLUENTD_CONF', '/fluent.conf'],
        ],

        'hosts'=>ConfigLib::build_hosts(['kafka'], true),
    },

    'attributes' => {

    }
})
