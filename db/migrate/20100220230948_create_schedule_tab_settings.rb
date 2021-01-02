class CreateScheduleTabSettings < ActiveRecord::Migration
  def self.up
    create_table :schedule_tab_settings do |t|
      t.string :item
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :schedule_tab_settings
  end
end
