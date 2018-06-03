require 'thor'
require_relative 'api'
require_relative 'config'

module GithubFlowCli
  class CLI < Thor
    desc "login", "login to Github with username and password"
    def login
      Config.username = ask("Github username: ")
      password = ask("password: ", echo: false)
      Config.oauth_token = API.login(Config.username, password)
      Config.save!
    rescue Config::BadConfig
      puts "bad username or password, please try again."
      retry
    end
  end
end
