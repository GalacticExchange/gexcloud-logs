namespace :servers do


  desc 'push and deploy image'
  task :push_and_deploy_image, :server_name, :version do  |task_name, p|
    srv = p[:server_name]
    version = p[:version]

    Rake::Task["servers:push_image"].invoke(srv, version)
    Rake::Task["servers:deploy_image"].invoke(srv, version)

  end

  desc 'push docker image to registry'
  task :push_image, :server_name, :version do  |task_name, p|
    gex_env = fetch(:gex_env)
    gex_config = fetch(:gex_config)
    srv = p[:server_name]
    version = p[:version]

    #
    host_servers = fetch(:host_servers)
    host_srv = host_servers[gex_config[:servers_by_hosts][srv]]


    #on roles(:host) do
    on host_srv do
      #as user: 'gex' do
      run_locally do
        #with rails_env: :main do
        image_name = "#{gex_config[:image_prefix]}#{srv}"

        puts "pushing image for server #{srv}"

        execute(:docker, "tag #{image_name} dockerhub.gex:5043/#{image_name}")

        execute(:docker, "login --username=gex --password=PH_GEX_PASSWD1 https://dockerhub.gex:5043")
        execute(:docker, "push dockerhub.gex:5043/#{image_name}")

      end
    end
  end


  desc 'deploy image to server'
  task :deploy_image, :server_name, :version do  |task_name, p|
    version = p[:version]
    gex_env = fetch(:gex_env)
    gex_config = fetch(:gex_config)
    dir_servers = gex_config[:dir_servers]

    srv = p[:server_name]
    image_name = "#{gex_config[:image_prefix]}#{srv}"

    #
    host_servers = fetch(:host_servers)
    host_srv = host_servers[gex_config[:servers_by_hosts][srv]]

    #on roles(:host) do
    on host_srv do
      user = fetch(:user) || 'gex'
      as user: user do
        ### work

        # pull image
        puts "pulling image for server #{srv}"

        execute(:docker, "login --username=gex --password=PH_GEX_PASSWD1 https://dockerhub.gex:5043")
        execute(:docker, "pull dockerhub.gex:5043/#{image_name}")
        execute(:docker, "tag dockerhub.gex:5043/#{image_name} #{image_name}:#{version} ")
        execute(:docker, "tag #{image_name}:#{version} #{image_name}:latest ")

      end
    end
  end

  desc 'rerun server'
  task :rerun, :server_name, :version do  |task_name, p|
    version = p[:version]

    gex_env = fetch(:gex_env)
    gex_config = fetch(:gex_config)
    dir_servers = gex_config[:dir_servers]

    srv = p[:server_name]

    # host servers
    host_servers = fetch(:host_servers)

    host_srv = host_servers[gex_config[:servers_by_hosts][srv]]

    #on roles(:srvhost) do
    on host_srv do
      user = fetch(:user) || 'gex'

      as user: user do
        execute 'hostname'
        #execute 'rvm list'
        #execute 'ruby -v'

        image_name = "#{gex_config[:image_prefix]}#{srv}"
        container_name = "#{gex_config[:container_prefix]}#{srv}"


        # first provision
=begin
        cmd = "docker-builder up -s #{srv}"
        execute "cd #{dir_servers} && bash --login -c '#{cmd}'"

        # export container to image
        cmd = %Q(docker commit -m "provisioned server #{container_name}" -a "Max Ivak" #{container_name} #{container_name}:temp )
        execute "#{cmd}"

        # remove container
        execute(:docker, "rm -f #{container_name}")

        # rename image
        execute(:docker, "rmi #{image_name}:latest ") rescue nil
        execute(:docker, "tag #{image_name}:temp #{image_name}:latest ")
        execute(:docker, "rmi #{image_name}:temp ")
=end


        # swarm service
        #execute(:docker, "service rm #{srv} || true")

        # backup current container
        tnow = Time.now
        st = tnow.strftime("%Y%m%d")+"_"+tnow.to_i.to_s
        cmd = %Q(docker commit -m "provisioned server #{container_name}" -a "Max Ivak" #{container_name} #{container_name}:backup-#{st} )
        #execute "#{cmd}" rescue nil


        puts "run docker container..."
        cmd = "docker-builder up -s #{srv} "
        execute "cd #{dir_servers} && bash --login -c '#{cmd}'"

      end
    end
  end


  desc 'start server'
  task :start, :server_name do  |task_name, p|
    on roles(:host) do
      user = fetch(:user) || 'gex'

      as user: user do
        gex_env = fetch(:gex_env)
        gex_config = fetch(:gex_config)
        dir_servers = gex_config[:dir_servers]

        srv = p[:server_name]
        image_name = "#{gex_config[:image_prefix]}#{srv}"
        container_name = "#{gex_config[:container_prefix]}#{srv}"

        puts "start docker container..."
        cmd = "docker-builder start -s #{srv} "
        execute "bash --login -c 'cd #{dir_servers} && #{cmd}'"

      end
    end
  end


  desc 'start all servers'
  task :start_all do  |task_name|
    gex_env = fetch(:gex_env)
    gex_config = fetch(:gex_config)
    dir_servers = gex_config[:dir_servers]

    user = fetch(:user) || 'gex'

    all_servers = gex_config[:servers_by_hosts]

    all_servers.each do |srv, h|
      Rake::Task["servers:start"].invoke(srv)
      Rake::Task["servers:start"].reenable
    end

  end

end



