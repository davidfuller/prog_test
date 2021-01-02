class CreateUploadPlaylistFiles < ActiveRecord::Migration
  def self.up
    create_table :upload_playlist_files do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :upload_playlist_files
  end
end
