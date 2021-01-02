class CreateMediaFiles < ActiveRecord::Migration
  def self.up
    create_table :media_files do |t|
      t.string :name
      t.string :filename
      t.integer :media_folder_id
      t.datetime :first_use
      t.datetime :last_use

      t.timestamps
    end
  end

  def self.down
    drop_table :media_files
  end
end
