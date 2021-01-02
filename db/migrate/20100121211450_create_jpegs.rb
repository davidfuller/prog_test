class CreateJpegs < ActiveRecord::Migration
  def self.up
    create_table :jpegs do |t|
      t.string :name
      t.string :filename
      t.integer :jpeg_folder_id

      t.timestamps
    end
  end

  def self.down
    drop_table :jpegs
  end
end
