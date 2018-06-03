require 'facets/string/snakecase'
require 'thor'
require_relative '../github_flow_cli/api'
require_relative '../github_flow_cli/config'

module GithubFlowCli
  class IssueCommands < Thor
    desc "create", "create an issue"
    def create(title)
      puts API.create_issue(title).html_url
    end

    desc "all", "get all open tickets"
    def all
      list_issues(assignee: '*', show_assignee: true)
    end

    desc "mine", "get open tickets assigned to me"
    def mine
      list_issues(assignee: Config.username)
    end

    desc "unassigned", "get unassigned open tickets"
    def unassigned
      list_issues(assignee: 'none')
    end

    desc "start", "create a new branch named after the issue"
    def start(number)
      issue = API.issue(Local.repo, number)
      # TODO: create branch based on RepoRules
      # TODO: abstarct tag from issue title
      branch_name = "TAG_#{number}_#{branch_name(issue.title)}"
      puts branch_name
    rescue Octokit::NotFound
      puts "issue not found!"
    end

    private

    def list_issues(config)
      show_assignee = config.delete(:show_assignee)
      defaults = { sort: :updated, direction: :desc }
      issues = API.list_issues(Local.repo, defaults.merge(config))
      if issues.empty?
        puts "no issue found."
      else
        puts issues.map { |i| "(#{i.updated_at}) ##{i.number}#{assignee_field(show_assignee, i)}: #{i.title}" }.join("\n")
      end
    end

    def assignee_field(show_assignee, issue)
      show_assignee ? " (#{issue.assignee.login})" : ''
    end

    def branch_name(title)
      title.gsub(/[^_\w\d ]/, '').snakecase
    end
  end
end
