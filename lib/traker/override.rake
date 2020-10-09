# frozen_string_literal: true

require_relative '../traker'

Traker::Instrumenter.new(Rake::Task.tasks).instrument do |task_name, handle_task|
  original_task = Rake.application.instance_variable_get('@tasks').delete(task_name)
  task_prerequisites = original_task.prerequisites | ['environment']
  task_description = original_task.full_comment

  desc task_description
  task task_name => task_prerequisites do
    handle_task.call do
      original_task.invoke
    end
  end
end
