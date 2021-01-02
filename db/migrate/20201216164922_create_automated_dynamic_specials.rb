class CreateAutomatedDynamicSpecials < ActiveRecord::Migration
  def self.up
    create_table :automated_dynamic_specials do |t|
      t.string :name
      t.integer :channel_id
      t.datetime :last_use
      t.integer :dynamic_special_template_id

      t.timestamps
    end
  end

  def self.down
    drop_table :automated_dynamic_specials
  end
end
