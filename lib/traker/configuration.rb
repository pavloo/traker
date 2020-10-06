# frozen_string_literal: true

require 'yaml'

module Traker
  # Holds Traker's configuration info
  class Configuration
    attr_accessor :config, :env

    def initialize
      @config = YAML.safe_load(File.read(Rails.root.join('.traker.yml')))
      @env = ENV.fetch('TRAKER_ENV', 'default')
    end

    def tasks
      config['environments'][env] || []
    end
  end
end
