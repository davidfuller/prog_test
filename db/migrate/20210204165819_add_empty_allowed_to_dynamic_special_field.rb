class AddEmptyAllowedToDynamicSpecialField < ActiveRecord::Migration
  def self.up
    add_column :dynamic_special_fields, :empty_allowed, :boolean
  end

  def self.down
    remove_column :dynamic_special_fields, :empty_allowed
  end
end
