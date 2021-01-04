class CreateDynamicSpecialMedias < ActiveRecord::Migration
  def self.up
    create_table :dynamic_special_medias do |t|
      t.integer :media_file_id
      t.integer :dynamic_special_image_spec_id

      t.timestamps
    end
  end

  def self.down
    drop_table :dynamic_special_medias
  end
end
