require 'octokit'
require_relative 'local'

module GithubFlowCli
  class API
    class << self
      # @return [String] OAuth token
      def authorize(username, password, two_factor_token: nil)
        client = Octokit::Client.new(login: username, password: password)
        auth_config = {
          scopes: ['user', 'repo', 'admin:repo_hook'],
          note: app_name,
        }
        if two_factor_token
          auth_config.merge!(:headers => { "X-GitHub-OTP" => two_factor_token })
        end
        client.create_authorization(auth_config).token
      rescue Octokit::UnprocessableEntity => ex
        if ex.message =~ /already_exists/
          id = client.authorizations.find { |auth| auth[:note] == app_name }.id
          client.delete_authorization(id)
          retry
        else
          raise
        end
      end

      def use_oauth_token(token)
        @client = Octokit::Client.new(access_token: token)
      end

      def valid?
        !user[:login].nil?
      rescue Octokit::Unauthorized
        false
      end

      # delegate API calls to Octokit::Client
      def method_missing(method, *args, &block)
        if @client.respond_to?(method)
          define_singleton_method(method) do |*args, &block|
            @client.send(method, *args, &block)
          end
          return send(method, *args, &block)
        end
        super
      end

      # TODO: explicify options
      # :assignee (String) — User login.
      # :milestone (Integer) — Milestone number.
      # :labels
      # TODO: keywordify parameters
      def create_issue(title, body = nil, options = {})
        @client.create_issue(Local.repo, title, body, options)
      end

      # TODO: other options
      def create_pr(base: "master", title: nil, body: nil)
        branch_name = Local.git.branch.name
        issue_number = Config.branch_issue_map[branch_name]
        if issue_number
          issue = API.issue(Local.repo, issue_number)
          title ||= issue.title
          body ||= issue.body
        end
        pr = @client.create_pull_request(Local.repo, base, branch_name, title, body)
        Config.link_pr_to_branch(pr, branch_name)
      end

      private

      def app_name
        "hubflow for #{`whoami`.strip}@#{`hostname`.strip}"
      end
    end
  end
end
