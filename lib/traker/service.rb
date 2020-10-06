# frozen_string_literal: true

require 'traker/configuration'
require 'traker/task'

module Traker
  # Service that incapsulates main Traker API
  class Service
    def initialize
      @config = Configuration.new
    end

    def pending_tasks
      tasks = @config.tasks.map { |t| t['name'] }
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
  end
end
