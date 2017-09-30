require_relative 'lib/helpers'

desc 'Rerun all images'
namespace :rerun do
  task :all, [:env, :v] do |t, args|

    env_name = args[:env]
    version = args[:v]

    # todo: throw an error here - rewrite it!
    require_relative "config.#{env_name}.rb" rescue nil

    ConfigCommon::SERVERS.each do |srv_name, srv|
      cmd = "cap #{env_name} servers:rerun['#{srv_name}','#{version}']"
      res = Helpers.execute_cmd_system(cmd)
      Helpers.puts_err("RERUN FOR #{srv_name} FAILED") unless res
    end

  end
end