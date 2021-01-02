class AddFieldsToAutomatedDynamicSpecialField < ActiveRecord::Migration
  def self.up
    add_column :automated_dynamic_special_fields, :the_id, :integer
    add_column :automated_dynamic_special_fields, :the_display, :string
  end

  def self.down
    remove_column :automated_dynamic_special_fields, :the_display
    remove_column :automated_dynamic_special_fields, :the_id
  end
end
