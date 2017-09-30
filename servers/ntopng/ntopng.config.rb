add_config({
  'build' => {
      'build_type' => 'Dockerfile',
      "image_name" => "ntopng",
  },
  'docker'=> {
      #"command"=> "",
      'volumes' => [],
      'links' => [],
      'run_env'=>[],
      'run_extra_options'=>'--privileged',
      'run_options'=>'',

  },
  'attributes' => {
  }
})
