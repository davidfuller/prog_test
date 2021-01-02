class CreateDivaTasks < ActiveRecord::Migration
  def self.up
    create_table :diva_tasks do |t|
      t.integer :system_id
      t.string :task_type
      t.string :name
      t.integer :task_index
      t.datetime :completed

      t.timestamps
    end
  end

  def self.down
    drop_table :diva_tasks
  end
end
