require 'thor'

module GithubFlowCli
  class CLI < Thor
    desc "login", "login to Github with username and password"
    def login
      username = ask("Github username: ")
      password = ask("password: ", echo: false)
      puts "TODO: login to github OAuth"
    end
  end
end
