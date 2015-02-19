require "coveralls"
Coveralls.wear!("rails")
require File.join(File.dirname(__FILE__), 'support/vcr')
require "mocha/api"

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.mock_with :mocha

  config.order = :random

  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end
