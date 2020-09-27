# frozen_string_literal: true

class AddTrakerTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :traker_tasks do |t|
      t.string :name, null: false
      t.string :environment, null: false
      t.boolean :is_success
      t.integer :run_count, default: 0
      t.text :error
      t.datetime :started_at, null: false
      t.datetime :finished_at, null: false
    end

    add_index :traker_tasks, %i(name environment)
  end
end
