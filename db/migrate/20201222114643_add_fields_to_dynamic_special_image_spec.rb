class AddFieldsToDynamicSpecialImageSpec < ActiveRecord::Migration
  def self.up
    add_column :dynamic_special_image_specs, :logo, :boolean
  end

  def self.down
    remove_column :dynamic_special_image_specs, :logo
  end
end
