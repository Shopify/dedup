# Dedup

Deep object deduplication.

If your app keeps lots of static data in memory, such as i18n data or large configurations,
this can reduce memory retention.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dedup'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dedup

## Usage

This library is meant to be called on large static data structures loaded during boot:

```ruby
SOME_DATA = Dedup.deep_intern!(YAML.load_file('path.yml'))
```

Keep in mind that it trades CPU during boot reduced for memory retention.
It isn't meant to be applied on runtime data with reduced lifetime, but on
static data loaded during boot.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dedup.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
