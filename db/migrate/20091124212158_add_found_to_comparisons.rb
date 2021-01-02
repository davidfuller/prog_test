class AddFoundToComparisons < ActiveRecord::Migration
  def self.up
    add_column :comparisons, :found_house, :boolean
    add_column :comparisons, :found_title, :boolean
  end

  def self.down
    remove_column :comparisons, :found_house
    remove_column :comparisons, :found_title
  end
end
