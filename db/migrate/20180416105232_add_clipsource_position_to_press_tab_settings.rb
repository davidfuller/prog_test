class AddClipsourcePositionToPressTabSettings < ActiveRecord::Migration
  def self.up
    add_column :press_tab_settings, :clipsource_position, :integer
  end

  def self.down
    remove_column :press_tab_settings, :clipsource_position
  end
end
