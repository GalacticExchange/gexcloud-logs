add_config({
        'build' => {
            'build_type' => 'none',
            "image_name" => "",

            "base_image" => { "name" => "zookeeper", "repository" => "zookeeper", "tag" => "3.4.9" },
        },
        'docker'=> {
            #"command"=> "",

            'volumes' => [

            ],
            'links' => [],
            'run_env'=>[
            ],

        },
        'attributes' => {
        }
    })
