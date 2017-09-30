class ServerConfig
  attr_accessor :name, :properties
  attr_accessor :env


  def initialize(_name)
    self.name = _name

    @attributes = {}
  end


  def env
    return @env if @env

    @env = $gex_env

    @env
  end


  ###


  def get_binding
    return binding()
  end


  def properties
    return @properties unless @properties.nil?

    @properties ||= {}

    @properties
  end


  ### some properties
  def dir_data
    $config_common[:DIR_GEXCLOUD_DATA]
  end

  def dir_mount_data
    $config_common[:DIR_MOUNT_DATA]
  end



  ### dsl

  def add_config(a)
    # merge
    build(a['build']) if a['build']
    provision(a['provision']) if a['provision']
    docker(a['docker']) if a['docker']
    attributes(a['attributes']) if a['attributes']


  end

  def build(v)
    properties['build'] = v
  end

  def provision(v)
    properties['provision'] = v
  end

  def docker(a)
    # merge
    properties['docker'] ||= {}

    a.each do |k,v|
      properties['docker'][k] = v
    end
  end

  def attributes(a)
    # merge
    properties['attributes'] ||= {}

    a.each do |k,v|
      properties['attributes'][k] = v
    end
  end

end


class ConfigLib


  def self.build_servers_config
    #
    servers_config = {}

    $config_common[:SERVERS].keys.each do |s|
      #
      #puts "build config for server #{s}"

      #
      f = "servers/#{s}/#{s}.config.#{$config_common[:GEX_ENV]}.rb"
      #(require_relative f) if File.exists?(f)
      server_file_config = f if File.exists?(f)

      f = "servers/#{s}/#{s}.config.rb"
      #(require_relative f) if File.exists?(f)
      server_file_config = f if File.exists?(f)


      next unless  server_file_config

      # build server config
      servers_config[s] = ConfigLib.build_server_config(s, server_file_config)
    end

    servers_config
  end


  def self.build_server_config(name, file_config)
    config = ServerConfig.new(name)

    # process config
    text = File.read(file_config)
    eval(text, config.get_binding)


    # base settings
    config.properties['docker']['ports'] ||= ConfigLib::build_ports(name)
    config.properties['docker']['network'] ||= ConfigLib::build_network(name)
    config.properties['docker']['run_extra_options'] ||= ConfigLib::docker_server_run_options(name)

    #puts "#{config.properties}"
    #exit

    config.properties
  end

  ###
  def self.docker_server_swarm_options(server_name)
    #--hostname #{server_name}
    " --restart-delay 10s  --restart-max-attempts 2 --replicas 1  --constraint node.hostname==#{$config_common[:NODES_BY_SERVERS][server_name]}"
  end

  def self.docker_server_hosts(server_name)
    $config_common[:HOSTS].map{|h| "--add-host #{h[1]}:#{h[0]}"}.join(" ")
  end


  # no swarm
  def self.docker_server_run_options(server_name)
    opts = $config_common[:SERVERS][server_name]
    return "" if opts.empty?

    s_opts = []

    # network
=begin
    default_network=$config_common[:DEFAULT_NETWORK]
    if default_network
      # default docker bridge
      s_opts << "--net=#{$config_common[:DEFAULT_NETWORK]}"
    else
      # private network
      s_opts << "--net=#{$config_common[:PRIVATE_NETWORK]}"
      s_opts << "--ip=#{opts[:ip]}" if opts[:ip]
    end
=end

    # resolv.conf
    s_opts << "--dns=8.8.8.8"

    #
    res = "--cap-add=NET_ADMIN -h #{server_name} #{s_opts.join(' ')}  #{opts['run_options']}"
    res
  end


  def self.build_network(server_name)
    opts = $config_common[:SERVERS][server_name]
    return nil if opts.nil? || opts.empty?

    #
    res = {}

    #
    networks = []

    # default network
    default_network = $config_common[:DEFAULT_NETWORK]

=begin
    if !opts[:remove_default_bridge].nil? && opts[:remove_default_bridge]
      networks << {
          'net'=> $config_common[:DEFAULT_NETWORK],
          'action'=> 'remove',
      }
    end
=end

    if default_network
      # default bridge
      network_default = {
          'net'=>$config_common[:DEFAULT_NETWORK],
      }

      #networks << a_bridge if a_bridge
    end

    # private network
    private_network_name = $config_common[:PRIVATE_NETWORK]

    if private_network_name
      network_private = {
          'net'=> private_network_name,
          'ip'=> opts[:ip],
      }
      #networks << network_private
    end


    # public network
    #network_public = docker_server_settings_network_public(server_name)
    #networks << a_public if a_public

    if opts[:public_ip]
      network_public = {
          'net'=> $config_common[:PUB_NETWORK],

      }

      ip = opts[:public_ip]
      network_public['ip'] = ip if ip

      mac_address = opts[:mac_address]
      network_public['mac_address'] = mac_address if mac_address

    end


    # gateway - only if public network
    if opts[:public_ip] && opts[:mac_address]
      gw = $config_common[:NETWORK_DEFAULT_GATEWAY]
      res['default_gateway'] = gw if gw
    end

    if opts[:public_gateway]
      res['default_gateway'] = opts[:public_gateway]
    end


        # if mac_address
    if opts[:mac_address]
      networks << network_public if network_public
      networks << network_private if network_private
      networks << network_default if network_default
    else
      networks << network_default if network_default
      networks << network_private if network_private
      networks << network_public if network_public
    end


    #
    res['networks'] = networks


    #puts "res=#{res}"

    res
  end





  def self.build_ports(server_name)
    opts = $config_common[:SERVERS][server_name]
    return [] if opts.nil? || opts.empty?


    opts[:ports]
  end

  # build hosts ips<->name in private network
  def self.build_hosts(a_hosts=nil, include_common=true, hosts_common=nil)
    res = []
    if include_common
      $config_common[:HOSTS].each do |s|
        res << s
      end
    end

    # hosts
    if a_hosts.nil?
      a_hosts = $config_common[:SERVERS].keys
    end

    a_hosts.each do |name|
      s = $config_common[:SERVERS][name.to_s]
      next if s.nil?
      res << [s[:ip], name]
    end

    ## common
    if hosts_common
      hosts_common.each do |name|
        s = $config_common[:HOSTS_BY_SERVERS][name.to_s]
        next if s.nil?
        res << [s, name]
      end
    end

    res
  end

  def self.build_mounts
    res = []
    $config_common[:MOUNTS].each do |s|
      res << "#{s[0]} #{s[1]} #{s[2]} #{s[3]}"
    end
    res
  end


  def self.build_mounts_data

  end

  # keys - array of names from files/ssh
  def self.build_ssh_keys(keys)
    ### ssh
    #file_path_env = File.expand_path("../../../.env", __FILE__)
    current_dir = File.dirname(__FILE__)
    dir_files = File.expand_path('files/', current_dir)
    dir_ssh = File.expand_path('files/ssh', current_dir)


    ### ssh keys
    # pub_keys_paths
    pub_keys_paths = []
    pub_keys_content = []

    #API_DOCKER_SSH_KEYS ||= ENV['API_DOCKER_SSH_KEYS'] || 'mmx/id_rsa.pub'


    # parse files with ssh keys
    #a = API_DOCKER_SSH_KEYS.split /,/
    #a.each do |pp|
    keys.each do |key_name|
      p = key_name+"/id_rsa.pub"

      if p =~ /^\//
        f = p
      else
        f = File.expand_path(p, dir_ssh)
      end

      #puts "ff: #{f}"

      next if f.empty?
      next unless File.exists? f

      pub_keys_paths << f
      pub_keys_content << IO.read(f)
    end

    pub_keys_content
  end
end
