class CreatePriorities < ActiveRecord::Migration
  def self.up
    create_table :priorities do |t|
      t.datetime :start
      t.integer :press_filename_id

      t.timestamps
    end
  end

  def self.down
    drop_table :priorities
  end
end
