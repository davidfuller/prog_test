class CreatePressLines < ActiveRecord::Migration
  def self.up
    create_table :press_lines do |t|
      t.datetime :start
      t.string :display_title
      t.string :original_title

      t.timestamps
    end
  end

  def self.down
    drop_table :press_lines
  end
end
