# frozen_string_literal: true

namespace :traker do
  desc 'successful task'
  task :rake_success do
    puts 'Victory.'
  end

  desc 'failing task'
  task :rake_fail do
    raise 'Failure.'
  end

  desc 'ignored task'
  task :rake_ingore do
    rake 'This is never run.'
  end
end
