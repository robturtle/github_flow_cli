require 'fileutils'
require 'ostruct'
require 'yaml'
require_relative 'cache'

module GithubFlowCli
  class Store < OpenStruct
    STORE_ROOT = File.expand_path('~/.config/hubflow/')

    class << self
      def [](file_name)
        path = File.join(STORE_ROOT, file_name)
        STORE_CACHE[path] || new(path) # TODO: AOP cache
      end
    end

    attr_reader :path

    def initialize(path)
      @path = path
      if File.file?(path)
        YAML::load_file(path).each { |k, v| send("#{k}=", v) }
      end
      STORE_CACHE[path] = self # TODO: AOP cache
    end

    def save!
      ensure_directory(File.dirname(path))
      File.open(config_path, 'w') { |f| f.write(to_h.to_yaml) }
    end

    private

    def ensure_directory(dirname)
      return if File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
  end
end
