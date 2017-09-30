add_config({
  'build' => {
      'build_type' => 'Dockerfile',
      "image_name" => "redis",
  },
  'docker'=> {
      #"command"=> "",
      'volumes' => [
          ['data','/data']
      ],
      'links' => [],
      'run_env'=>[
      ],

      'run_options'=>'--appendonly yes',

  },
  'attributes' => {
  }
})
