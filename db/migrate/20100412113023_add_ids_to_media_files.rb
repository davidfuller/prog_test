class AddIdsToMediaFiles < ActiveRecord::Migration
  def self.up
      add_column :media_files, :status_id, :integer
      add_column :media_files, :media_type_id, :integer
  end

  def self.down
      remove_column :media_files, :status_id
      remove_column :media_files, :media_type_id
  end
end
