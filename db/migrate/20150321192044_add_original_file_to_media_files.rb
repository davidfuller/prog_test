class AddOriginalFileToMediaFiles < ActiveRecord::Migration
  def self.up
    add_column :media_files, :original_filename, :string
  end

  def self.down
    remove_column :media_files, :original_filename
  end
end
