class CreateSpecialScheduleSettings < ActiveRecord::Migration
  def self.up
    create_table :special_schedule_settings do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :special_schedule_settings
  end
end
