class AddSpecialPreviewToAutomatedDynamicSpecial < ActiveRecord::Migration
  def self.up
    add_column :automated_dynamic_specials, :special_preview_id, :integer
  end

  def self.down
    remove_column :automated_dynamic_specials, :special_preview_id
  end
end
