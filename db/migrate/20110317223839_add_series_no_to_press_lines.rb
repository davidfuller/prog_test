class AddSeriesNoToPressLines < ActiveRecord::Migration
  def self.up
      add_column :press_lines, :series_number, :string
  end

  def self.down
      remove_column :press_lines, :series_number
  end
end
