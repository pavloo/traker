# frozen_string_literal: true

require 'active_record'

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = nil
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  ActiveRecord::Migration.migrate(File.join(__FILE__, '..', '..', 'lib', 'generators', 'traker', 'templates', 'migrations'))
end
