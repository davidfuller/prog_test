class AddFirstUseToAutomatedDynamicSpecials < ActiveRecord::Migration
  def self.up
    add_column :automated_dynamic_specials, :first_use, :datetime
  end

  def self.down
    remove_column :automated_dynamic_specials, :first_use
  end
end
