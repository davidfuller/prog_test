class CreatePressTabSettings < ActiveRecord::Migration
  def self.up
    create_table :press_tab_settings do |t|
      t.string :item
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :press_tab_settings
  end
end
