require 'yaml'
require 'fileutils'
require_relative 'api'

module GithubFlowCli
  class Config
    CONFIG_DIR = File.expand_path('~/.config')
    CONFIG_FILE = 'hubflow'
    KEYS = %w[username oauth_token]

    class << self
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

      def load
        YAML::load_file(config_path).each { |k, v| send("#{k}=", v) }
      end

      def save!
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
end
