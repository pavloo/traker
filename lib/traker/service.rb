# frozen_string_literal: true

require 'traker/task'

module Traker
  # Service that encapsulates main Traker API
  class Service
    def initialize
      @config = Traker::Config.load
    end

    def pending_tasks
      records = Traker::Task.where(name: tasks, environment: @config.env)
      actual = tasks.each_with_object({}) do |name, hash|
        record = records.find { |r| r.name == name }
        hash[name] = record ? record.run_count : 0
      end

      pending = []
      tasks.each do |name|
        actual[name] -= 1
        next if actual[name] >= 0

        pending << name
      end

      pending
    end

    def tasks
      @tasks ||= @config.tasks.map { |t| t['name'] }
    end
  end
end
