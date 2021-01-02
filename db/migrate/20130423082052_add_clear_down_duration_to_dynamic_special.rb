class AddClearDownDurationToDynamicSpecial < ActiveRecord::Migration
  def self.up
    add_column :dynamic_specials, :clear_down_page_number, :integer
    add_column :dynamic_specials, :clear_down_duration, :integer
  end

  def self.down
    remove_column :dynamic_specials, :clear_down_page_number
    remove_column :dynamic_specials, :clear_down_duration
  end
end
