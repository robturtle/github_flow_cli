module GithubFlowCli
  module Stores
    class Repo

      class << self
        def [](repo)
          STORE_CACHE[config_path(repo)] || new(repo)
        end

        def config_path(repo)
          "repos/#{repo.slug.sub('/', '.')}"
        end
      end

      # @param repo [Octokit::Repository]
      def initialize(repo)
        @repo = repo
        setup_store
      end

      def link_branch_to_issue_number(branch_name, issue_number)
        @store.issue_number_of_branch[branch_name] = issue_number
      end

      def link_pr_to_branch(pr_number, branch_name)
        @store.branch_of_pr[pr_number] = branch_name
      end

      private

      def setup_store
        @store = Store[Repo.config_path(repo)]
        @store.issue_number_of_branch ||= {}
        @store.branch_of_pr || {}
      end
    end
  end
end
