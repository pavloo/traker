# frozen_string_literal: true

module Traker
  class Task < ActiveRecord::Base
    self.table_name_prefix = 'traker_'
  end
end
