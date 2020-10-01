# frozen_string_literal: true

require 'yaml'

module Traker
  class Instrumenter
    attr_accessor :tasks

    def initialize(tasks)
      @tasks = tasks
    end

    def instrument
      tasks.each do |t|
        task_name = t.name

        next unless tasks_to_be_run.map { |task| task['name'] }.include?(task_name)

        handler = proc do |&block|
          record = Traker::Task.find_or_initialize_by(name: task_name, environment: env)

          record.started_at = DateTime.now
          record.is_success = true

          begin
            block.call
          rescue => e
            record.is_success = false
            record.error = e.backtrace.first
            raise e
          ensure
            record.run_count += 1
            record.finished_at = DateTime.now
            record.save!
          end
        end

        yield task_name, handler
      end
    end

    private

    def config
      @config ||= YAML.safe_load(File.read(File.join(Rails.root, '.traker.yml')))
    end

    def env
      @env ||= ENV.fetch('TRAKER_ENV', 'default')
    end

    def tasks_to_be_run
      config['environments'][env] || []
    end
  end
end
