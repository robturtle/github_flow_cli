require 'yaml'
require 'fileutils'

module GithubFlowCli
  class Config
    CONFIG_DIR = File.expand_path('~/.config')
    CONFIG_FILE = 'hubflow'
    KEYS = %w[username oauth_token]

    class BadConfig < StandardError; end

    class << self
      attr_accessor *KEYS

      def load
        YAML::load_file(config_path).each { |k, v| send("#{k}=", v) }
      ensure
        unless valid?
          puts "WARN: bad configuration #{to_h}"
          KEYS.each { |k| send("#{k}=", nil) }
        end
      end

      def save!
        raise BadConfig, "bad configuration #{to_h}" unless valid?
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

    if File.file?(config_path)
      load
    end
  end
end
