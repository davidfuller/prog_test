class AddArchiveToAutomatedDynamicSpecials < ActiveRecord::Migration
  def self.up
    add_column :automated_dynamic_specials, :archive, :boolean
  end

  def self.down
    remove_column :automated_dynamic_specials, :archive
  end
end
