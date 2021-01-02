class CreatePlaylistFilenames < ActiveRecord::Migration
  def self.up
    create_table :playlist_filenames do |t|
      t.string :filename
      t.date :schedule_date

      t.timestamps
    end
  end

  def self.down
    drop_table :playlist_filenames
  end
end
