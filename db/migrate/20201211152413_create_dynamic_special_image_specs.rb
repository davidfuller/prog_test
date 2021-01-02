class CreateDynamicSpecialImageSpecs < ActiveRecord::Migration
  def self.up
    create_table :dynamic_special_image_specs do |t|
      t.string :name
      t.integer :height
      t.integer :width
      t.boolean :resizable

      t.timestamps
    end
  end

  def self.down
    drop_table :dynamic_special_image_specs
  end
end
