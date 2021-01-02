class AddLastUseToDynamicSpecial < ActiveRecord::Migration
  def self.up
    add_column :dynamic_specials, :last_use, :datetime
  end

  def self.down
    remove_column :dynamic_specials, :last_use
  end
end
