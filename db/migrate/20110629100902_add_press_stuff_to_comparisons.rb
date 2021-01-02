class AddPressStuffToComparisons < ActiveRecord::Migration
  def self.up
    add_column :comparisons, :series_ident, :string
    add_column :comparisons, :year, :string
    add_column :comparisons, :comparison_code, :string
    add_column :comparisons, :press_id, :integer
  end

  def self.down
    remove_column :comparisons, :series_ident
    remove_column :comparisons, :year
    remove_column :comparisons, :comparison_code
    remove_column :comparisons, :press_id
  end
end
