# Traker

Traker is a *Rake task tracker for Rails applications*. When integrated, it keeps track of rake tasks that have been run and stores that information in database.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'traker'
```

And then execute:

    $ bundle

## Usage
1. Add the next snippet to your `Rakefile` after `Rails.application.load_tasks`

```ruby
# Rails.application.load_tasks has to be above of the code we add

spec = Gem::Specification.find_by_name 'traker'
load File.join(spec.gem_dir, 'lib', 'traker', 'override.rake')
```

2. Run generator

``` ruby
rails g traker:models migration
```

3. Run `rake db:migrate`
4. Set `TRAKER_ENV` environment variable (see below)

### Configuration file
Traker with only care about tasks that are specified in it's configuration file `.traker.yml`. Here is the example of such a file:

``` yml
environments:
  dev:
    - name: traker:test1
      notes: Some fancy description here
    
    - name: traker:test2

  stg:
    - name: traker:test1
```
Schema breakdown:
* `environments.<key>` - the name of the environment (`TRAKER_ENV`) the task has to be run against
* `environments.<key>.name` - the name of the rake task in namespace:name format
* `environments.<key>.notes` - some information that might be important when the task is run (should be different from rake task's description)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pavloo/traker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Traker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pavloo/traker/blob/master/CODE_OF_CONDUCT.md).
