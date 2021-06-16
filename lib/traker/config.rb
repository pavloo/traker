# frozen_string_literal: true

require 'yaml'
require 'rails'

module Traker
  # Represents Traker configuration.
  class Config
    PATH = '.traker.yml'

    class InvalidTasks < StandardError
    end

    def self.load
      Config.new(File.join(::Rails.root, PATH))
    end

    def initialize(file)
      yml = YAML.safe_load(File.read(file))
      @environments = yml['environments']
    rescue Psych::SyntaxError => e
      puts "[TRAKER] unable to load config file: #{e}"
      @environments = {}
    end

    def env
      @env ||= ENV.fetch('TRAKER_ENV', 'default')
    end

    def tasks
      @environments[env] || []
    end

    def validate!(available_tasks)
      available_task_names = available_tasks.map { |t| extract_task_name(t[:name]) }

      @environments.each do |_, tasks|
        task_names = (tasks || []).map { |t| extract_task_name(t['name']) }
        invalid_tasks = task_names - available_task_names

        if invalid_tasks.any?
          raise InvalidTasks, "#{PATH} contains invalid tasks: #{invalid_tasks.join(',')}"
        end
      end
    end

    private

    # Extracts task name without arguments
    def extract_task_name(str)
      matches = str.match(/^(?<name>[^\[\]]*)(?:(\[.*\])?)$/) # Task name with optional parameters
      if matches.try(:names).blank?
        raise InvalidTasks, "#{PATH} contains a bad formatted task: #{str}"
      else
        matches[:name]
      end
    end
  end
end
