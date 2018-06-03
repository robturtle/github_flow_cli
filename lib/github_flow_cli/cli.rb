require 'thor'
require_relative 'api'
require_relative 'config'
require_relative 'local'

module GithubFlowCli
  class CLI < Thor
    desc "login", "login to Github with username and password"
    def login
      Config.username = ask("Github username:")
      password = ask("password:", echo: false)
      Config.oauth_token = authorize(Config.username, password)
      Config.save!
      puts "\nsuccessfully login!"
    rescue Octokit::Unauthorized
      puts "\nauthentication failed, please try again."
      retry
    end

    desc "user", "display username"
    def user
      puts API.user[:login]
    end

    desc "repo", "display remote repo name"
    def repo
      puts(Local.repo&.slug || "remote repo not found!")
    end

    private

    def authorize(username, password)
      API.authorize(username, password)
    rescue Octokit::OneTimePasswordRequired
      two_factor_token = ask("\nTwo Factor Authentication code:")
      API.authorize(username, password, two_factor_token: two_factor_token)
    end
  end
end
