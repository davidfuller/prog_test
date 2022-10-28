class CreateSpecialScheduleLogs < ActiveRecord::Migration
  def self.up
    create_table :special_schedule_logs do |t|
      t.integer :channel_id
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :start_time
      t.datetime :end_time
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :special_schedule_logs
  end
end
