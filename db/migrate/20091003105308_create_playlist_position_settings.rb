class CreatePlaylistPositionSettings < ActiveRecord::Migration
  def self.up
    create_table :playlist_position_settings do |t|
      t.string :item
      t.integer :position
      t.integer :length

      t.timestamps
    end
  end

  def self.down
    drop_table :playlist_position_settings
  end
end
