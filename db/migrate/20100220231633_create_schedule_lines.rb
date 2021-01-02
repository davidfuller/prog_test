class CreateScheduleLines < ActiveRecord::Migration
  def self.up
    create_table :schedule_lines do |t|
      t.datetime :start
      t.string :house_no
      t.string :title
      t.string :series_title

      t.timestamps
    end
  end

  def self.down
    drop_table :schedule_lines
  end
end
