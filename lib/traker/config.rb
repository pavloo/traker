# frozen_string_literal: true

require 'yaml'

module Traker
  # Represents Traker configuration.
  class Config
    PATH = '.traker.yml'

    class InvalidTasks < StandardError
    end

    def self.load
      Config.new(File.join(Rails.root, PATH))
    end

    def initialize(file)
      yml = YAML.safe_load(File.read(file))
      @environments = yml['environments']
    end

    def env
      @env ||= ENV.fetch('TRAKER_ENV', 'default')
    end

    def tasks_to_be_run
      @environments[env] || []
    end

    def validate!(available_tasks)
      available_task_names = available_tasks.map(&:name)

      @environments.each do |_, tasks|
        task_names = tasks.map { |t| t['name'] }
        invalid_tasks = task_names - available_task_names

        if invalid_tasks.any?
          raise InvalidTasks, "#{PATH} contains invalid tasks: #{invalid_tasks.join(',')}"
        end
      end
    end
  end
end
