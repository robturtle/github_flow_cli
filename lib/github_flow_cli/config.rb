require 'yaml'
require 'fileutils'
require_relative 'api'
require_relative 'local'

module GithubFlowCli
  class Config; end
  class << Config
    CONFIG_DIR = File.expand_path('~/.config')
    CONFIG_FILE = 'hubflow'
    KEYS = %w[username oauth_token branch_issue_map pr_branch_map]

    attr_accessor *KEYS

    def setup
      if File.file?(config_path)
        load
        API.use_oauth_token(oauth_token)
        unless API.valid?
          puts "WARN: authentication failed, please retry login."
          File.delete(config_path)
          exit(1)
        end
      else
        puts "please login first."
        exit(2)
      end
    end

    def link_branch_to_issue(branch_name, issue)
      self.branch_issue_map[branch_name] = issue.number
    end

    def link_pr_to_branch(pr, branch_name)
      self.pr_branch_map[pr.number] = branch_name
    end

    def load
      YAML::load_file(config_path).each { |k, v| send("#{k}=", v) }
    end

    def save!
      self.branch_issue_map ||= {}
      self.pr_branch_map ||= {}
      File.open(config_path, 'w') { |f| f.write(to_h.to_yaml) }
    end

    def to_h
      KEYS.map{ |k| [k, send(k)] }.to_h
    end

    def valid?
      KEYS.all? { |c| send(c) }
    end

    def config_path
      FileUtils.mkdir_p(CONFIG_DIR) unless File.directory?(CONFIG_DIR)
      File.join(CONFIG_DIR, CONFIG_FILE)
    end
  end
end
