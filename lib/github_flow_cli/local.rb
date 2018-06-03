require 'git'

module GithubFlowCli
  class Local
    class << self
      def repo
        url = Git.open(File.expand_path('.')).remote.url.sub(/\.git$/, '')
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
