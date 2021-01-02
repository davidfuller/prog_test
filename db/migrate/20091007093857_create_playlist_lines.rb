class CreatePlaylistLines < ActiveRecord::Migration
  def self.up
    create_table :playlist_lines do |t|
      t.integer :event
      t.datetime :start
      t.time :duration
      t.string :source
      t.string :material_type
      t.string :material_id
      t.string :title
      t.string :long_title

      t.timestamps
    end
  end

  def self.down
    drop_table :playlist_lines
  end
end
