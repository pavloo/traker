# frozen_string_literal: true

require 'active_record'

module Traker
  # Represents a rake task that have been run and logged by Traker
  class Task < ActiveRecord::Base
    self.table_name_prefix = 'traker_'
  end
end
