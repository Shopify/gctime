# GCTime

Exposes a monotonically increasing GC total_time metric.

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
require 'gctime'
>> GCTime.total_time
=> 0.0
>> GCTime.enable
=> nil
>> 4.times { GC.start }
=> 4
>> GCTime.total_time
=> 0.12742100000000012
>> GCTime.disable
=> nil
```

## Incompatibilities

`CGTime` relies on the built-in [`GC::Profiler`](https://ruby-doc.org/core-3.0.0/GC/Profiler.html) which is a stateful datastructure. Which mean any other gem or application code using it
is likely incompatoble with `GCTime` and will likely lead to incorrect timings.

Known incompatible gems are:

  - [`newrelic_rpm`](https://github.com/newrelic/newrelic-ruby-agent/blob/4baffe79b87e6ec725dfae9f5e76113a1f1d01ba/lib/new_relic/agent/vm/monotonic_gc_profiler.rb#L22-L38)

## Memory Leak

It is important to note that the underlying `GC::Profiler` keeps internal records of all GC triggers. Every time `GCTime.total_time` is called the datastructure is reset,
but if it isn't called on a regular basis, it might lead to a memory leak.

Make sure to either call it on a regular basis, or to disable it when it's no longer needed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Shopify/gctime.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
