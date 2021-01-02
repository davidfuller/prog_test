class CreateJpegFolders < ActiveRecord::Migration
  def self.up
    create_table :jpeg_folders do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :jpeg_folders
  end
end
