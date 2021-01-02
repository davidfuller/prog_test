class AddRoundedToPlaylistLines < ActiveRecord::Migration
  def self.up
    add_column :playlist_lines, :rounded, :datetime
  end

  def self.down
    remove_column :playlist_lines, :rounded
  end
end
