# frozen_string_literal: true

RSpec.describe Traker::CLI do
  context 'list subcommand' do
    context 'return tasks' do
      before do
        allow_any_instance_of(
          Traker::Service
        ).to receive(:pending_tasks).and_return(['traker:test1', 'traker:test2'])
        allow_any_instance_of(
          Traker::Service
        ).to receive(:tasks).and_return(['traker:test1'])
      end

      it 'returns list of pending tasks' do
        argv = ['list']
        output = "traker:test1\ntraker:test2"
        expect { described_class.new.run(argv) }.to output(output).to_stdout
      end

      it 'returns list of all tasks' do
        argv = ['list', '-a']
        output = 'traker:test1'
        expect { described_class.new.run(argv) }.to output(output).to_stdout
      end
    end
  end

  context 'main options' do
    it 'returns version' do
      argv = ['-v']
      output = "#{Traker::VERSION}\n"
      expect { described_class.new.run(argv) }.to output(output).to_stdout
    end
  end
end
