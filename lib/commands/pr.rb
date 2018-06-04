require 'thor'
require_relative '../github_flow_cli/api'
require_relative '../github_flow_cli/config'

module GithubFlowCli
  class PrCommands < Thor
    desc "all", "list all open PR"
    def all
      pull_requests = API.pull_requests(Local.repo)
      unless pull_requests.empty?
        puts pull_requests.map { |p| "##{p.number} (#{p.assignee&.login || "NONE"}): #{p.title}" }
      end
    end
  end
end
