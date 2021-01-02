class CreateChannels < ActiveRecord::Migration
  def self.up
    create_table :channels do |t|
      t.string :name
      t.string :press_code
      t.string :playlist_code
      t.integer :language_id

      t.timestamps
    end
  end

  def self.down
    drop_table :channels
  end
end
