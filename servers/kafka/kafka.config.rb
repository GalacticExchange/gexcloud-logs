#KAFKA_PORT_IN = 9092
#KAFKA_PORT_OUT = 9092

#KAFKA_IP = $config_common[:SERVERS][NAME][:ip]
#KAFKA_LISTENERS = "PLAINTEXT://0.0.0.0:#{KAFKA_PORT_IN}"


#def self.kafka_advertised_host
#  NAME
#end

#def self.kafka_advertised_listeners
#  "PLAINTEXT://#{$config_common[:SERVERS][NAME][:public_ip]}:#{KAFKA_PORT_IN}"
#end



add_config({
        'build' => {
            'build_type' => 'Dockerfile',
            "image_name" => "kafka",
        },
        'docker'=> {
            #"command"=> "",
            'volumes' => [
                ["/var/run/docker.sock", '/var/run/docker.sock'],
                ['data', '/kafka']
            ],
            'links' => [],
            'run_env'=>[
                ['KAFKA_BROKER_ID', 88],
                ['KAFKA_LISTENERS', "PLAINTEXT://0.0.0.0:9092"],
                ['KAFKA_ADVERTISED_LISTENERS', "PLAINTEXT://#{$config_common[:SERVERS]['kafka'][:ip]}:9092"],

                #['KAFKA_ADVERTISED_HOST_NAME', '77.0.0.72'],

                ['KAFKA_ZOOKEEPER_CONNECT', 'zookeeper:2181'],
                ['KAFKA_LOG_DIRS', '/kafka/kafka-logs'],

            ],

            'hosts'=>ConfigLib::build_hosts(['zookeeper'], true),
        },
        'attributes' => {
        }
})


