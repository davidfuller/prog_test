class CreateComparisons < ActiveRecord::Migration
  def self.up
    create_table :comparisons do |t|
      t.datetime :start
      t.datetime :rounded
      t.string :long_title
      t.string :house_no
      t.datetime :press_start
      t.string :original_title
      t.string :danish_title
      t.boolean :contained

      t.timestamps
    end
  end

  def self.down
    drop_table :comparisons
  end
end
