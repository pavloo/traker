# frozen_string_literal: true

require 'rails/generators/active_record'

module Traker
  module Generators
    # A rails generator that generates rspec-related files in the host
    # Ruby On Rails project
    class RspecGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def generate_spec
        template 'spec/lib/traker_spec.rb', 'spec/lib/traker_spec.rb'
      end
    end
  end
end
