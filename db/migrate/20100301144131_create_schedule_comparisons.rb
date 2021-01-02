class CreateScheduleComparisons < ActiveRecord::Migration
  def self.up
    create_table :schedule_comparisons do |t|
      t.datetime :start
      t.string :title
      t.string :house_number
      t.string :series_number
      t.datetime :press_start
      t.string :original_title
      t.string :local_title
      t.boolean :contained
      t.boolean :found_house
      t.boolean :found_series
      t.boolean :found_title

      t.timestamps
    end
  end

  def self.down
    drop_table :schedule_comparisons
  end
end
