# GithubFlowCli

Normally how do you push your code to Github to resolve a ticket? Probably like this:

1. go to Github issues page or your task manager, create a ticket;
2. create a branch locally;
3. finish your work, push it to Github;
4. go to Github project home page, click "new pull request";
5. redirect to "new pull request" page, fill in the title and other information.

I always found it a waste of my time doing the process above. Especially most of the time I type the same information again and again -- it's very likely the issue contents, the branch name, and the pr contents are connected. Also waiting response from the Chrome browser is not enjoyable.

This CLI tool is aiming to fasten the developing flow with Github by automating issue/PR creation according to the repo's convention. It's very new and primitive, but the goal is glory -- to make developing with Github as smoothly as possible!

## Installation

```
gem install github_flow_cli
```

## Usage

For the very first version, I present a workflow that is 100% browser-free until the PR reviewing phase. Here's an example:

![image](https://user-images.githubusercontent.com/3524125/40894925-82156c58-6761-11e8-9f21-2d467426bd58.png)

1. When you're in ready position, check your ticket list via `hubflow issue mine`;
2. Pick a ticket to work on via `hubflow issue start NUMBER`, this will create a branch based on the issue number and name;
3. After you finished your work, just hit `hubflow pr create`, it will:
   1. create a remote branch; 
   2. set upstream;
   3. push code;
   4. create PR based on the issue title.
   
And you can just copy the PR URL from the CLI output to your boss to request a review.

You can also create an issue via `hubflow issue create TITLE`
![image](https://user-images.githubusercontent.com/3524125/40895228-ee1c56a4-6762-11e8-9e5f-5efc4f6b90f7.png)

For other commands please refer to:
```
hubflow help
```

There's a huge room to improve, including but not limited to:

- custom issue title/branch name/PR title template
- custom issue body/PR body template
- interactive UI
- more automations

If you like this idea, not hesitate to join the development!

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/robturtle/github_flow_cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GithubFlowCli project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/robturtle/github_flow_cli/blob/master/CODE_OF_CONDUCT.md).
