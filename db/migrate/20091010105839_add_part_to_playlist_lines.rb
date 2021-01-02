class AddPartToPlaylistLines < ActiveRecord::Migration
  def self.up
    add_column :playlist_lines, :part, :integer
  end

  def self.down
    remove_column :playlist_lines, :part
  end
end
