# frozen_string_literal: true

namespace :traker do
  desc 'successful task'
  task rake_success: :environment do
    puts 'Victory.'
  end

  desc 'failing task'
  task rake_fail: :environment do
    raise 'Failure.'
  end

  desc 'ignored task'
  task rake_ingore: :environment do
    rake 'This is never run.'
  end
end
