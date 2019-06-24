# Specterr

Use Specterr to be able to monitor and track exceptions in your Rails
applications. Specterr gives an ability to use database of your own choice and
can be hosted anywhere as desired.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'specterr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install specterr

## Usage

This gem is still unpublished. To be able to use this gem right away, use github
source when adding gem to Gemfile as given below.

```ruby
gem "specterr", git: "https://github.com/dtreelabs/specterr.git"
```

## Development

For using the gem from local folder to a rails project use - 
```ruby
gem 'specterr', path: '<absolute path for developement folder>'
 
# for example
# gem 'specterr', path: '/usr/local/workspace/specterr'
```

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dtreelabs/specterr. Please refer [Getting Started](https://github.com/dtreelabs/specterr/wiki) wiki page to setup Specterr for development. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Specterr project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/specterr/blob/master/CODE_OF_CONDUCT.md).
