# frozen_string_literal: true

RSpec.describe Traker do
  it 'has a version number' do
    expect(Traker::VERSION).not_to be nil
  end

  context 'task is in the config' do
    it 'logs successful task' do
      traker_env = 'dev'
      with_modified_env TRAKER_ENV: traker_env do
        instrument_rake_tasks!
        task_name = 'traker:rake_success'
        Rake::Task[task_name].execute

        expect(Traker::Task.count).to eq 1
        record = Traker::Task.first

        expect(record.name).to eq task_name
        expect(record.environment).to eq traker_env
        expect(record.is_success).to be(true)
        expect(record.error).to be_nil
        expect(record.run_count).to eq 1
        expect(record.started_at).to be_instance_of(Time)
        expect(record.finished_at).to be_instance_of(Time)
      end
    end

    it 'increases task count' do
      traker_env = 'dev'
      with_modified_env TRAKER_ENV: traker_env do
        instrument_rake_tasks!
        task_name = 'traker:rake_success'

        Rake::Task[task_name].execute
        expect(Traker::Task.count).to eq 1
        record = Traker::Task.first
        expect(record.run_count).to eq 1

        Rake::Task[task_name].execute
        expect(Traker::Task.count).to eq 1
        record.reload
        expect(record.run_count).to eq 2
      end
    end

    it 'ignores task with the same name but from different environment' do
      traker_env = 'prd'
      with_modified_env TRAKER_ENV: traker_env do
        instrument_rake_tasks!
        task_name = 'traker:rake_success'

        Rake::Task[task_name].execute
        expect(Traker::Task.count).to eq 0
      end
    end
  end

  context 'task is not in config' do
    it 'ignores task that is not in the config file' do
      instrument_rake_tasks!
      task_name = 'traker:rake_ignore'

      Rake::Task[task_name].execute
      expect(Traker::Task.count).to eq 0
    end
  end
end
