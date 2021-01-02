class CreateDynamicSpecialTemplates < ActiveRecord::Migration
  def self.up
    create_table :dynamic_special_templates do |t|
      t.string :name
      t.integer :page_169
      t.integer :clear_down_169
      t.integer :page_43
      t.integer :clear_down_43
      t.integer :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :dynamic_special_templates
  end
end
