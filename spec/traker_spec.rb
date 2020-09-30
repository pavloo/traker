# frozen_string_literal: true

RSpec.describe Traker do
  it 'has a version number' do
    expect(Traker::VERSION).not_to be nil
  end

  it 'does something useful' do
    p Rake::Task.tasks
    Rake::Task['traker:rake_success'].invoke
  end
end
