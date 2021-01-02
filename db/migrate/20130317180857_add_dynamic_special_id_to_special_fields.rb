class AddDynamicSpecialIdToSpecialFields < ActiveRecord::Migration
  def self.up
      add_column :special_fields, :dynamic_special_id, :integer
  end

  def self.down
    remove_column :special_fields, :dynamic_special_id
  end
end
