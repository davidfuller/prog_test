class CreateDynamicSpecialFields < ActiveRecord::Migration
  def self.up
    create_table :dynamic_special_fields do |t|
      t.string :name
      t.integer :dynamic_special_image_spec_id

      t.timestamps
    end
  end

  def self.down
    drop_table :dynamic_special_fields
  end
end
