module GithubFlowCli
  module Stores
    class Config; end
    class << Config
      CONFIG_KEYS = %w[username oauth_token]
      delegate *CONFIG_KEYS, to: :store

      private

      def store
        Store['config']
      end
    end
  end
end
