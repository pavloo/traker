# frozen_string_literal: true

namespace :traker do
  # stubbed version of Rails's "environment" task
  task :environment do
  end

  desc 'successful task'
  task :rake_success do
    puts 'Victory.'
  end

  desc 'failing task'
  task :rake_fail do
    raise 'Failure.'
  end

  desc 'ignored task'
  task :rake_ignore do
    puts 'This task is just run and not support to be logged by Traker.'
  end
end
