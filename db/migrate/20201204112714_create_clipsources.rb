class CreateClipsources < ActiveRecord::Migration
  def self.up
    create_table :clipsources do |t|
      t.string :from
      t.string :to

      t.timestamps
    end
  end

  def self.down
    drop_table :clipsources
  end
end
