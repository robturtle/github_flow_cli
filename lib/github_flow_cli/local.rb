require 'git'

module GithubFlowCli
  class Local
    class << self
      # assume the remote name is "origin"
      def repo
        url = Git.open(File.expand_path('.')).remote.url
        return nil unless url
        Octokit::Repository.from_url(url)
      rescue ArgumentError => ex
        if ex.message =~ /path does not exist/
          nil
        else
          raise
        end
      end
    end
  end
end
