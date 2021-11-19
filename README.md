# GCTime

Backport Ruby 3.1's `GC.stat(:time)` and `GC.total_time`. This gem is a noop on Ruby 3.1+.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gctime'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gctime

## Usage

```ruby
>> GC.measure_total_time
=> true
>> 4.times { GC.start }
=> 4
>> GC.stat(:time)
=> 123 # milliseconds
>> GC.stat[:time]
=> 123 # milliseconds
>> GC.total_time
=> 123909999 # nanoseconds
>> GC.measure_total_time = false # Disable instrumentation
=> false
```

`GC.stat(:time)` and `GC.stat[:time]` returns the total number of milliseconds spent in GC as Integer on MRI and as Float on JRuby and TruffleRuby.

`GC.total_time` returns the total number of nanoseconds spent in GC as Integer.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Shopify/gctime.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
