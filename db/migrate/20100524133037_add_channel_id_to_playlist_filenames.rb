class AddChannelIdToPlaylistFilenames < ActiveRecord::Migration
  def self.up
      add_column :playlist_filenames, :channel_id, :integer
  end

  def self.down
      remove_column :playlist_filenames, :channel_id
  end
end
