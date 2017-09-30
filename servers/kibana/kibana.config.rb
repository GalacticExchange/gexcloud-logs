add_config({
        'build' => {
            'build_type' => 'Dockerfile',
            "image_name" => "kibana",

            "base_image" => { },
        },
        'docker'=> {
            "command"=> '/etc/bootstrap',  #'fluentd -c /fluentd/etc/fluent.conf',

            #"command"=> "",
            'volumes' => [
                #['./data/config', '/usr/share/kibana/config/'],
                ['data','/usr/share/kibana/data']
            ],
            'links' => [],
            'run_env'=>[
            ],
            'hosts'=>ConfigLib::build_hosts(['elasticsearch'], true),

        },
        'attributes' => {
        }
})
