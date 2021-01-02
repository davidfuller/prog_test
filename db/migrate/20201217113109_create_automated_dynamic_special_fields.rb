class CreateAutomatedDynamicSpecialFields < ActiveRecord::Migration
  def self.up
    create_table :automated_dynamic_special_fields do |t|
      t.string :the_value
      t.integer :automated_dynamic_special_id
      t.integer :template_field_join_id

      t.timestamps
    end
  end

  def self.down
    drop_table :automated_dynamic_special_fields
  end
end
