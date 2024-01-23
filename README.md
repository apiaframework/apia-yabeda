# Apia::Yabeda

This gem collects [Prometheus](https://prometheus.io/) metrics for applications that use [Apia](https://github.com/krystal/apia) for their API and [Yabeda](https://github.com/yabeda-rb/yabeda) for their metrics.

It records:

- The total number of requests handled by Apia (as a counter)
- Time spent in Apia requests in seconds (as a histogram)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apia-yabeda'
```

## Usage in Ruby on Rails

In an initializer, Hook into Apia's notifications by adding a handler that instruments the event with [ActiveSupport::Notifications](https://api.rubyonrails.org/classes/ActiveSupport/Notifications.html).

```ruby
require 'apia/yabeda'

Apia::Notifications.add_handler do |event, args|
  ActiveSupport::Notifications.instrument("#{event}.apia", args)
end
```

By requiring `apia/yabeda` we've trigged the Yabeda configuration automatically. `Apia::Yabeda` will then listen for these events and record metrics for them.

## Tests and Linting

- `bin/rspec`
- `bin/rubocop`

## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/krystal/apia-yabeda.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
