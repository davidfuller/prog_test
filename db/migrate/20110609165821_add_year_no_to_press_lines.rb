class AddYearNoToPressLines < ActiveRecord::Migration
  def self.up
      add_column :press_lines, :year_number, :string
  end

  def self.down
      remove_column :press_lines, :year_number
  end
end
