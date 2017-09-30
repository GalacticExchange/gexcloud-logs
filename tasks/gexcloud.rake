namespace :gexcloud do


  desc 'copy config files'
  task :copy_config_files do
    on roles(:host) do
      user = fetch(:user) || 'gex'
      as user: user do
        gex_env = fetch(:gex_env)
        gex_config = fetch(:gex_config)
        dir_servers = gex_config[:dir_servers]

        # config.rb
        upload! "config.#{gex_env}.rb", "#{dir_servers}/config.rb"
        upload! "config_lib.rb", "#{dir_servers}/config_lib.rb"

      end
    end
  end


  desc 'deploy servers'
  task :deploy do
    on roles(:host) do
      user = fetch(:user) || 'gex'
      as user: user do
        gex_env = fetch(:gex_env)
        gex_config = fetch(:gex_config)

        dir_servers = gex_config[:dir_servers]

        #
        #execute "cd #{dir_servers} && git stash && git pull origin master"
        execute "cd #{dir_servers} && git fetch && git reset --hard origin/master"

        #
        invoke 'gexcloud:copy_config_files'
      end
    end
  end


  desc 'deploy all - config + scripts'
  task :deploy_all do
    invoke 'gexcloud:copy_config_files'

    Rake::Task["gexcloud:copy_config_files"].reenable

    invoke 'gexcloud:deploy'
  end



  desc 'fix firewall'
  task :setup_firewall do
    on roles(:host) do
      user = fetch(:user) || 'gex'
      as user: user do
        gex_env = fetch(:gex_env)
        gex_config = fetch(:gex_config)

        dir_servers = gex_config[:dir_servers]

        # servers
        upload! "host/scripts/setup_firewall.sh", "/tmp/setup_firewall.sh"

        execute "sh /tmp/setup_firewall.sh"

      end
    end
  end


  desc 'install registry server'
  task :install_registry do
    on roles(:host) do
      user = fetch(:user) || 'gex'
      as user: user do
        #with rails_env: :main do
          gex_env = fetch(:gex_env)
          gex_config = fetch(:gex_config)

          #execute "cd /disk2/servers && touch temp1.txt"
          dir_server = gex_config[:dir_servers]+"/docker-registry"

          # copy config
          execute "mkdir -p #{dir_server}/servers/nginx/config"
          execute "rm -rf  #{dir_server}/servers/nginx/config.backup"
          execute "mv #{dir_server}/servers/nginx/config #{dir_server}/servers/nginx/config.backup"

          upload! "docker-registry/servers/nginx/config-#{gex_env}/",
                  "#{dir_server}/servers/nginx/config/",
                  recursive: true


          upload! "docker-registry/config.#{gex_env}.rb", "#{dir_server}/config.rb"

          upload! "docker-registry/install_cert_server.sh", "#{dir_server}/install_cert_server.sh"

          # install SSL certificate
          #execute "cd #{dir_server} && bash --login -c 'sh install_cert_server.sh'"
          execute "cd #{dir_server} && sh install_cert_server.sh"

          # run server
          execute "cd #{dir_server} && bash --login -c 'docker-builder up'"



        #end
      end
    end
  end

  desc 'run data container'
  task :run_data_container do
    on roles(:host) do
      user = fetch(:user) || 'gex'
      as user: user do
        #with rails_env: :main do
        gex_env = fetch(:gex_env)
        gex_config = fetch(:gex_config)

        dir_servers = gex_config[:dir_servers]

        srv = 'datapub'

        # build and run data container
        cmd = "docker-builder build -s #{srv}"
        execute "cd #{dir_servers} && bash --login -c '#{cmd}'"

        cmd = "docker-builder up -s #{srv}"
        execute "cd #{dir_servers} && bash --login -c '#{cmd}'"

      end
    end
  end


  desc 'update_scripts_chef'
  task :update_scripts_chef do
    on roles(:host) do
      user = fetch(:user) || 'gex'
      as user: user do
        gex_env = fetch(:gex_env)
        gex_config = fetch(:gex_config)
        dir_servers = gex_config[:dir_servers]

        srv = 'datapub'
        container_name="#{gex_config[:container_prefix]}#{srv}"

        # git pull
        #cmd = "bash -c -l \"cd /data/chef-repo && git pull origin master\" "
        cmd = "bash -c -l \"cd /scripts/chef-repo && /usr/bin/git pull origin master\" "
        execute :docker, %Q(exec #{container_name} #{cmd})

      end
    end
  end


  desc 'update_scripts_ansible'
  task :update_scripts_ansible do
    on roles(:host) do
      user = fetch(:user) || 'gex'
      as user: user do
        gex_env = fetch(:gex_env)
        gex_config = fetch(:gex_config)
        dir_servers = gex_config[:dir_servers]

        srv = 'datapub'
        container_name="#{gex_config[:container_prefix]}#{srv}"

        # git pull
        #cmd = "bash -c -l \"cd /data/chef-repo && git pull origin master\" "
        cmd = "bash -c -l \"cd /scripts/ansible && /usr/bin/git pull origin master\" "
        execute :docker, %Q(exec #{container_name} #{cmd})

      end
    end
  end


  desc 'start api'
  task :start_api_servers do
    on roles(:host) do
      user = fetch(:user) || 'gex'
      as user: user do
        gex_env = fetch(:gex_env)
        gex_config = fetch(:gex_config)
        dir_servers = gex_config[:dir_servers]

        servers = ['redis','mysql', 'elasticsearch',
        'phpmyadmin','phpredisadmin', 'api']

        servers.each do |srv|
          cmd = %Q(cd #{dir_servers} && docker-builder start -s #{srv})
          cmd_bash = "bash -c -l \"#{cmd}\" "
          execute %Q(#{cmd_bash})
        end

      end
    end
  end

end

