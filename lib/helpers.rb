module Helpers

  # without terminal output, returns output
  def self.execute_cmd(cmd)
    puts "cmd: #{cmd}"
    `#{cmd}`
  end


  # output in terminal, returns true/false
  def self.execute_cmd_system(cmd)
    puts "cmd: #{cmd}"
    system("#{cmd}")
  end


  # other
  def self.puts_ln(str)
    puts "----------------------- #{str} -----------------------"
  end


  def self.puts_err(str)
    red = ' " $(tput setaf 1) !!! '+str+' !!! " '
    system("echo #{red}")
    system("tput sgr0")
  end

end