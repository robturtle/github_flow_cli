require 'git'

module GithubFlowCli
  class Local
    class << self
      def repo
        url = Git.open(File.expand_path('.')).remote.url
        match = url&.match(%r{.*[:/](?<owner>.*?)/(?<name>.*?)\.git$})
        return nil unless match[:owner] && match[:name]
        Octokit::Repository.from_url("/#{match[:owner]}/#{match[:name]}")
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
