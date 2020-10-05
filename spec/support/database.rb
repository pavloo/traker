# frozen_string_literal: true

require 'active_record'

ActiveRecord::Migration.verbose = true
ActiveRecord::Base.logger = nil
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  ActiveRecord::MigrationContext.new(
    File.join(__dir__, '..', '..', 'lib', 'generators', 'traker', 'templates', 'migrations')
  ).migrate
end
