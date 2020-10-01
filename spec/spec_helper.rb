# frozen_string_literal: true

require 'bundler/setup'
require 'active_record'
require 'database_cleaner'
require 'support/database'
require 'rake'
require 'rails'
require 'climate_control'
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
  end

  config.before(:example) do
    allow(::Rails).to receive(:root).and_return(File.join(__dir__, 'support'))
  end

  config.around(:each) do |example|
    if ActiveRecord::Base.connected?
      DatabaseCleaner.cleaning { example.run }
    else
      example.run
    end
  end
end

def with_modified_env(options, &block)
  ClimateControl.modify(options, &block)
end

def instrument_rake_tasks!
  Rake::Task.tasks.each do |task|
    name = task.name
    Rake.application.instance_variable_get('@tasks').delete(name)
  end
  Rake.load_rakefile(File.join(__dir__, 'support', 'traker.rake'))
  Rake.load_rakefile(File.join(__dir__, '..', 'lib', 'traker', 'override.rake'))
end
