# frozen_string_literal: true

require 'rails/generators/active_record'

module Traker
  module Generators
    class ModelsGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def generate_model
        migration_template 'migrations/20200930011917_add_traker_tasks.rb', 'db/migrate/add_traker_tasks.rb'
      end
    end
  end
end
