class AddFieldsToDynamicSpecialTemplate < ActiveRecord::Migration
  def self.up
    add_column :dynamic_special_templates, :demo, :string
  end

  def self.down
    remove_column :dynamic_special_templates, :demo
  end
end
