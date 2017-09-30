add_config({
        'build' => {
            'build_type' => 'none',
            "image_name" => "elasticsearch",

            "base_image" => {
                "name" => "elasticsearch",
                "repository" => "elasticsearch",
                "tag" => "2.3.5"
            },
        },
        'docker'=> {
            #"command"=> "",
            'volumes' => [
                ['./data/config', '/usr/share/elasticsearch/config'],
                ['data','/usr/share/elasticsearch/data'],
                ['elasticsearch_logs','/usr/share/elasticsearch/logs'],
            ],
            'links' => [],
            'run_env'=>[],

        },
        'attributes' => {
        }
})
