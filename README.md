# mentorboat

We're using ruby 2.5.0. It's best to use postmodern's [chruby](https://github.com/postmodern/chruby) and [ruby-install](https://github.com/postmodern/ruby-install) for no-nonsense ruby version management. If something else is working for you, you're all set to go!

Our database is postgresql. [Postgresapp](http://postgresapp.com) is a livesaver. If you have postgresql installed any other way - make sure you know how to nuke them first before using this app, or don't use it at all.
In any case, ensure the server is running before running `rails server`.

Run `bundle install` whenever you want to get every dependency installed for this app.

For models or controllers, you'll find some test cases in [minitest](https://github.com/seattlerb/minitest).
`bin/rake test` will run all the tests.
Thoughtbot's gems we use for tests include: [factory-bot](https://github.com/thoughtbot/factory_bot) for Rails and [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers).

All authentication is done with [clearance](https://github.com/thoughtbot/clearance). There's some custom routes configured for it, so you'll find everything defined explicitly in `routes.rb` and controller files.

To deploy, create a branch, make a PR request, and let CI pass. Merge to master and it automatically deploys to [production](https://dashboard.heroku.com/apps/mentorboat-v1-production) on Heroku.
If you need to quickly check that your stuff works, force push your branch to `staging`. That will let you skip CI and quickly see what you worked on on the [staging app](https://dashboard.heroku.com/apps/mentorboat-v1-staging). Whatever's in the `staging` branch is automatically deployed! Make sure to rebase `master` first just to keep things aligned.

⛵🚀
