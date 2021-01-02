class AddSeriesNumberToScheduleLines < ActiveRecord::Migration
  def self.up
    add_column :schedule_lines, :series_number, :string
  end

  def self.down
    remove_column :schedule_lines, :series_number
  end
end
