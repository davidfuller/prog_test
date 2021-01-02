class CreateSpecialFields < ActiveRecord::Migration
  def self.up
    create_table :special_fields do |t|
      t.integer :number
      t.string :description
      t.string :default_text

      t.timestamps
    end
  end

  def self.down
    drop_table :special_fields
  end
end
