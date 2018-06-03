require 'octokit'

module GithubFlowCli
  class API
    class << self
      # @return [String] OAuth token
      def authorize(username, password, two_factor_token: nil)
        client = Octokit::Client.new(login: username, password: password)
        auth_config = {
          scopes: ['repo', 'admin:repo_hook'],
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
          return @client.send(method, *args, &block)
        end
        super
      end

      private

      def app_name
        "hubflow for #{`whoami`.strip}@#{`hostname`.strip}"
      end
    end
  end
end
