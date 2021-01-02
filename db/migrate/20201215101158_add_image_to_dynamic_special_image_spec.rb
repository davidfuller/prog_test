class AddImageToDynamicSpecialImageSpec < ActiveRecord::Migration
  def self.up
    add_column :dynamic_special_image_specs, :image, :boolean
  end

  def self.down
    remove_column :dynamic_special_image_specs, :image
  end
end
