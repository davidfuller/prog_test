class CreateDynamicSpecialLogos < ActiveRecord::Migration
  def self.up
    create_table :dynamic_special_logos do |t|
      t.string :name
      t.string :filename
      t.string :display_filename
      t.integer :dynamic_special_image_spec_id
      t.integer :language_id

      t.timestamps
    end
  end

  def self.down
    drop_table :dynamic_special_logos
  end
end
