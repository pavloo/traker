# frozen_string_literal: true

require 'bundler/setup'
require 'active_record'
require 'database_cleaner'
require 'support/database'
require 'rake'
require 'traker'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    # import File.join(__dir__, 'support', 'traker.rake')
    # import File.join(__dir__, '..', 'lib', 'traker.rake')
    # p Rake::Task.tasks
  end

  config.around(:each) do |example|
    if ActiveRecord::Base.connected?
      DatabaseCleaner.cleaning { example.run }
    else
      example.run
    end
  end
end
