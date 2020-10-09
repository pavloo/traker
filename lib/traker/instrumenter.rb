# frozen_string_literal: true

module Traker
  # Wraps array of rake tasks, and auguments each one of them
  # with Traker features
  class Instrumenter
    attr_accessor :tasks, :config

    def initialize(tasks)
      @tasks = tasks
      @config = Traker::Config.load
    end

    def instrument
      tasks.each do |t|
        task_name = t.name

        next unless tasks_to_be_run.map { |task| task['name'] }.include?(task_name)

        handler = proc do |&block|
          record = Traker::Task.find_or_initialize_by(name: task_name, environment: config.env)

          record.started_at = DateTime.now
          record.is_success = true

          begin
            block.call
            record.run_count += 1
          rescue StandardError => e
            record.is_success = false
            record.error = e.backtrace.first
            raise e
          ensure
            record.finished_at = DateTime.now
            record.save!
          end
        end

        yield task_name, handler
      end
    end

    private

    def tasks_to_be_run
      config.tasks
    end
  end
end
