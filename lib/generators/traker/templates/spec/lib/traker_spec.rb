# frozen_string_literal: true

require 'traker'

describe '.traker.yml' do
  it 'is valid' do
    Rails.application.load_tasks
    expect { Traker::Config.load.validate!(Rake::Task.tasks) }.not_to raise_error
  end
end
