class AddPlaylistFilenameIdToPlaylistLine < ActiveRecord::Migration
  def self.up
    add_column :playlist_lines, :playlist_filename_id, :integer
  end

  def self.down
    remove_column :playlist_lines, :playlist_filename_id
  end
end
