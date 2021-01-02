class CreateHouses < ActiveRecord::Migration
  def self.up
    create_table :houses do |t|
      t.string :house_number
      t.integer :title_id

      t.timestamps
    end
  end

  def self.down
    drop_table :houses
  end
end
