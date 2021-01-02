class AddPressStuffToScheduleComparisons < ActiveRecord::Migration
  def self.up
    add_column :schedule_comparisons, :series_ident, :string
    add_column :schedule_comparisons, :year, :string
    add_column :schedule_comparisons, :comparison_code, :string
    add_column :schedule_comparisons, :press_id, :integer
end

  def self.down
    remove_column :schedule_comparisons, :series_ident
    remove_column :schedule_comparisons, :year
    remove_column :schedule_comparisons, :comparison_code
    remove_column :schedule_comparisons, :press_id    
  end
end
