require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.filter_sensitive_data('<FLOW TOKEN>') { ENV['FLOWDOCK_TEST_TOKEN'] }
  c.default_cassette_options = { record: :new_episodes }
  c.configure_rspec_metadata!
end
