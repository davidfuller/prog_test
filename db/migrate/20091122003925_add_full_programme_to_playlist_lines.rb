class AddFullProgrammeToPlaylistLines < ActiveRecord::Migration
  def self.up
    add_column :playlist_lines, :full_programme, :boolean
  end

  def self.down
    remove_column :playlist_lines, :full_programme
  end
end
