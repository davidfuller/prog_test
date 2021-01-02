class CreateMediaFolders < ActiveRecord::Migration
  def self.up
    create_table :media_folders do |t|
      t.string :name
      t.string :folder
      t.integer :channel_id
      t.boolean :clip
      t.boolean :system

      t.timestamps
    end
  end

  def self.down
    drop_table :media_folders
  end
end
