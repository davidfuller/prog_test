class CreateTemplateFieldJoins < ActiveRecord::Migration
  def self.up
    create_table :template_field_joins do |t|
      t.integer :field
      t.integer :dynamic_special_template_id
      t.integer :dynamic_special_field_id

      t.timestamps
    end
  end

  def self.down
    drop_table :template_field_joins
  end
end
