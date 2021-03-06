
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "github_flow_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "github_flow_cli"
  spec.version       = GithubFlowCli::VERSION
  spec.authors       = ["Yang Liu"]
  spec.email         = ["jeremyrobturtle@gmail.com"]

  spec.summary       = "CLI of github-flow."
  spec.description   = "Github-flow provides you a CLI to interact with Github and automate the workflow."
  spec.homepage      = "https://github.com/robturtle/github_flow_cli"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "facets" # String#snakecase, common utils
  spec.add_dependency "git"
  spec.add_dependency "octokit" # Github API
  spec.add_dependency "thor" # CLI

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
