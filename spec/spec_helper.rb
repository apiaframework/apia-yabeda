# frozen_string_literal: true

require "bundler/setup"
require "apia"
require "apia/yabeda"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect

    config.before(:suite) do
      Yabeda.configure! # applies the configure block called by PrometheusCollector (not required for Rails apps)
    end
  end
end
