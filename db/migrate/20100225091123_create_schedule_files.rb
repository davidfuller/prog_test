class CreateScheduleFiles < ActiveRecord::Migration
  def self.up
    create_table :schedule_files do |t|
      t.string :name
      t.integer :channel_id
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end

  def self.down
    drop_table :schedule_files
  end
end
