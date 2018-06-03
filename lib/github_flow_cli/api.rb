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
    end
  end
end
