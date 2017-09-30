add_config({
    'build' => {
        'build_type' => 'Dockerfile',
        "image_name" => "logs-fluentd-docker-containers",

    },

    'provision' => {

    },


    'docker' => {
        "command"=> '/etc/bootstrap',

        'volumes' => [

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
