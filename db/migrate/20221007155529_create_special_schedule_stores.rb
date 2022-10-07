class CreateSpecialScheduleStores < ActiveRecord::Migration
  def self.up
    create_table :special_schedule_stores do |t|
      t.datetime :start
      t.integer :press_filename_id
      t.integer :join_id

      t.timestamps
    end
  end

  def self.down
    drop_table :special_schedule_stores
  end
end
