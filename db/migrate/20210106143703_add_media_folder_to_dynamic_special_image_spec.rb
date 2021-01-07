class AddMediaFolderToDynamicSpecialImageSpec < ActiveRecord::Migration
  def self.up
    add_column :dynamic_special_image_specs, :media_folder_id, :integer
  end

  def self.down
    remove_column :dynamic_special_image_specs, :media_folder_id
  end
end
