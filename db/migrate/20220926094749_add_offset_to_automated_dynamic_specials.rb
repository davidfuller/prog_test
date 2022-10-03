class AddOffsetToAutomatedDynamicSpecials < ActiveRecord::Migration
  def self.up
    add_column :automated_dynamic_specials, :offset, :integer
  end

  def self.down
    remove_column :automated_dynamic_specials, :offset
  end
end
