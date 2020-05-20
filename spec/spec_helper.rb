# frozen_string_literal: true

require 'bundler/setup'
require 'messy_broker'

SPEC_ROOT = Pathname.new('.').dirname.join('spec').expand_path

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

SPEC_ROOT.glob('support/*.rb').each { |x| require x }
