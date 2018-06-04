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

    desc "create TITLE", "create PR from current branch"
    def create(title = nil)
      pr =  API.create_pr(title: title)
      puts pr.html_url if pr
    rescue Octokit::UnprocessableEntity => ex
      if ex.message =~ /no commits between .*? and/i
        puts "No commits between base and head, stop creating PR..."
      else
        raise
      end
    end
  end
end
