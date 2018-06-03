require 'thor'
require_relative 'api'

module GithubFlowCli
  class CLI < Thor
    desc "login", "login to Github with username and password"
    def login
      username = ask("Github username: ")
      password = ask("password: ", echo: false)
      oauth_token = API.login(username, password)
      # TODO: save jwt token
    end
  end
end
