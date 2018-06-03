require 'thor'
require_relative '../github_flow_cli/api'

module GithubFlowCli
  class IssueCommands < Thor
    desc "create", "create an issue"
    def create(title)
      puts API.create_issue(title).url
    end
  end
end
