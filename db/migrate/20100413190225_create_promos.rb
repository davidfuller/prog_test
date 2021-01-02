class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos do |t|
      t.string :name
      t.string :description
      t.integer :title_id
      t.datetime :first_use
      t.datetime :last_use
      
      t.timestamps
    end
  end

  def self.down
    drop_table :promos
  end
end
