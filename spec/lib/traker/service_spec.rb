# frozen_string_literal: true

RSpec.describe Traker::Service do
  context 'pending tasks' do
    it 'returns list of new tasks' do
      expect(described_class.new.pending_tasks).to eq(['traker:rake_success', 'traker:rake_success1'])
    end

    it 'excludes task that has been already run' do
      instrument_rake_tasks!
      Rake::Task['traker:rake_success'].execute

      expect(described_class.new.pending_tasks).to eq(['traker:rake_success1'])
    end

    it 'returns empty list' do
      instrument_rake_tasks!
      Rake::Task['traker:rake_success'].execute
      Rake::Task['traker:rake_success1'].execute

      expect(described_class.new.pending_tasks).to be_empty
    end

    it 'returns list when task appears more than once' do
      with_modified_env TRAKER_ENV: 'stg' do
        instrument_rake_tasks!
        Rake::Task['traker:rake_success'].execute

        expect(described_class.new.pending_tasks).to eq(['traker:rake_success', 'traker:rake_success1'])
      end
    end
  end
end
