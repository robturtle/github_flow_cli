require 'octokit'

module GithubFlowCli
  class API
    class << self
      # @return [String] OAuth token
      def authorize(username, password, two_factor_token: nil)
        client = Octokit::Client.new(login: username, password: password)
        auth_config = {
          scopes: ['repo', 'admin:repo_hook'],
          note: "hubflow for #{`whoami`}@#{`hostname`}",
        }
        if two_factor_token
          auth_config.merge!(:headers => { "X-GitHub-OTP" => two_factor_token })
        end
        client.create_authorization(auth_config).token
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
          return @client.send(method, *args, &block)
        end
        super
      end
    end
  end
end
