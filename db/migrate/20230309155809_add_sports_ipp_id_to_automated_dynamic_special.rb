class AddSportsIppIdToAutomatedDynamicSpecial < ActiveRecord::Migration
  def self.up
    add_column :automated_dynamic_specials, :sports_ipp_id, :integer
  end

  def self.down
    remove_column :automated_dynamic_specials, :sports_ipp_id
  end
end
