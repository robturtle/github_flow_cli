require 'thor'

module GithubFlowCli
  class CLI < Thor
    desc "hello NAME", "say hello to NAME"
    def hello(name)
      puts "hello, #{name}"
    end
  end
end
