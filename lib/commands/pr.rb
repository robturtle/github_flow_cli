require 'thor'
require_relative '../github_flow_cli/api'
require_relative '../github_flow_cli/config'

module GithubFlowCli
  class PrCommands < Thor
    desc "all", "list all open PR"
    def all
      puts "TODO"
    end
  end
end
