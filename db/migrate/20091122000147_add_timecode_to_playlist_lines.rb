class AddTimecodeToPlaylistLines < ActiveRecord::Migration
  def self.up
    add_column :playlist_lines, :timecode, :time
  end

  def self.down
    remove_column :playlist_lines, :timecode
  end
end
