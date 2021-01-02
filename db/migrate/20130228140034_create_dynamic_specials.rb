class CreateDynamicSpecials < ActiveRecord::Migration
  def self.up
    create_table :dynamic_specials do |t|
      t.string :name
      t.integer :channel_id
      t.integer :page

      t.timestamps
    end
  end

  def self.down
    drop_table :dynamic_specials
  end
end
