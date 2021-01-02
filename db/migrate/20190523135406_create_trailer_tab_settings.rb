class CreateTrailerTabSettings < ActiveRecord::Migration
  def self.up
    create_table :trailer_tab_settings do |t|
      t.integer :position
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :trailer_tab_settings
  end
end
