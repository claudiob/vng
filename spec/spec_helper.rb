require 'simplecov'
SimpleCov.minimum_coverage 100
SimpleCov.start

require 'vng'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.order = :random

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
