class CreateSpecialPreviews < ActiveRecord::Migration
  def self.up
    create_table :special_previews do |t|
      t.string :name
      t.integer :media_file_id

      t.timestamps
    end
  end

  def self.down
    drop_table :special_previews
  end
end
