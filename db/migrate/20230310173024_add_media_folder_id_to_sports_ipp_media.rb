class AddMediaFolderIdToSportsIppMedia < ActiveRecord::Migration
  def self.up
    add_column :sports_ipp_medias, :media_folder_id, :integer
  end

  def self.down
    remove_column :sports_ipp_medias, :media_folder_id
  end
end
