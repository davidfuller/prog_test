class CreatePressLineAutomatedDynamicSpecialJoins < ActiveRecord::Migration
  def self.up
    create_table :press_line_automated_dynamic_special_joins do |t|
      t.integer :press_line_id
      t.integer :automated_dynamic_special_id
      t.integer :part_id
      t.integer :offset

      t.timestamps
    end
  end

  def self.down
    drop_table :press_line_automated_dynamic_special_joins
  end
end
