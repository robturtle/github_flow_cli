require 'git'

module GithubFlowCli
  class Local
    class << self
      def repo
        return @repo if @repo
        url = git.remote.url
        match = url&.match(%r{.*[:/](?<owner>.*?)/(?<name>.*?)\.git$})
        return nil unless match[:owner] && match[:name]
        @repo = Octokit::Repository.from_url("/#{match[:owner]}/#{match[:name]}")
      rescue ArgumentError => ex
        if ex.message =~ /path does not exist/
          nil
        else
          raise
        end
      end

      def git
        @git ||= Git.open(File.expand_path('.'))
      end
    end
  end
end
