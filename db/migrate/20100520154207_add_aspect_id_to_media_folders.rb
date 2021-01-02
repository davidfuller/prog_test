class AddAspectIdToMediaFolders < ActiveRecord::Migration
  def self.up
      add_column :media_folders, :aspect_id, :integer
  end

  def self.down
      remove_column :media_folders, :aspect_id
  end
end
