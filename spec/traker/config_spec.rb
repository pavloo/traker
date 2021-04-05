# frozen_string_literal: true

RSpec.describe Traker::Config do
  subject { Traker::Config.load }

  describe '.load' do
    it { is_expected.not_to be_blank }
  end

  describe '#initialize' do
    it 'does not fail if config has incorrect syntax' do
      expect { Traker::Config.new('./spec/support/.invalid_traker.yml') }
        .not_to raise_error
    end
  end

  describe '#env' do
    it 'returns default env' do
      expect(subject.env).to eq 'default'
    end

    it 'returns the modified env' do
      with_modified_env TRAKER_ENV: 'dev' do
        expect(subject.env).to eq 'dev'
      end
    end
  end

  describe '#tasks_to_be_run' do
    it 'returns default tasks to be run' do
      with_modified_env TRAKER_ENV: 'dev' do
        expect(subject.tasks)
          .to eq [{ 'name' => 'traker:rake_success' }, { 'name' => 'traker:rake_fail' }]
      end
    end
  end

  describe '#validate!' do
    let(:available_tasks) do
    end

    it 'raises if there is a task mismatch' do
      available_tasks = [
        OpenStruct.new(name: 'task1'),
        OpenStruct.new(name: 'task2')
      ]
      expect { subject.validate!(available_tasks) }
        .to raise_error Traker::Config::InvalidTasks, '.traker.yml contains invalid tasks: traker:rake_success,traker:rake_fail'
    end

    it 'validates if tasks match' do
      available_tasks = [
        OpenStruct.new(name: 'traker:rake_success1'),
        OpenStruct.new(name: 'traker:rake_success'),
        OpenStruct.new(name: 'traker:rake_fail')
      ]
      expect { subject.validate!(available_tasks) }.not_to raise_error
    end
  end
end
