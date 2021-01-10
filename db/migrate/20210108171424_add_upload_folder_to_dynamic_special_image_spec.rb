class AddUploadFolderToDynamicSpecialImageSpec < ActiveRecord::Migration
  def self.up
    add_column :dynamic_special_image_specs, :upload_folder, :string
  end

  def self.down
    remove_column :dynamic_special_image_specs, :upload_folder
  end
end
