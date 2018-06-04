require 'thor'
require_relative '../github_flow_cli/api'
require_relative '../github_flow_cli/config'

module GithubFlowCli
  class PrCommands < Thor
    desc "all", "list all open PR"
    def all
      # TODO: before filer
      unless Local.repo
        puts "not valid outside of a git repo."
        exit(4)
      end
      pull_requests = API.pull_requests(Local.repo)
      unless pull_requests.empty?
        puts pull_requests.map { |p| "#{Local.repo ? '' : i.repository.name}##{p.number} (#{p.assignee&.login || "NONE"}): #{p.title}" }
      end
    end

    desc "create TITLE", "create PR from current branch"
    def create(title = nil)
      # TODO: before filer
      unless Local.repo
        puts "not valid outside of a git repo."
        exit(4)
      end
      puts API.create_pr(title: title).html_url
    rescue Octokit::UnprocessableEntity => ex
      case ex.message
      when /no commits between .*? and/i
        puts "No commits between base and head, stop creating PR..."
      when /already exists/
        puts "PR already exists."
        pr_number = Config.pr_branch_map.find {|_, v| v == Local.git.current_branch }.first
        puts API.pull_request(Local.repo, pr_number).html_url
      when /missing_field/
        puts "issue info lost, please provide the title"
      else
        raise
      end
    end
  end
end
