require 'thor'
require_relative 'api'
require_relative 'config'

module GithubFlowCli
  class CLI < Thor
    desc "login", "login to Github with username and password"
    def login
      Config.username = ask("Github username:")
      password = ask("password:", echo: false)
      Config.oauth_token = authorize(Config.username, password)
      Config.save!
    rescue Config::BadConfig
      puts "\nbad username or password, please try again."
      retry
    end

    desc "user", "display username"
    def user
      puts API.user[:login]
    end

    private

    def authorize(username, password)
      API.authorize(username, password)
    rescue Octokit::OneTimePasswordRequired
      two_factor_token = ask("\nTwo Factor Authentication code:")
      API.authorize(Config.username, password, two_factor_token: two_factor_token)
    end
  end
end
