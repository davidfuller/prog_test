class AddPressFilenameIdToPressLines < ActiveRecord::Migration
  def self.up
    add_column :press_lines, :press_filename_id, :integer
  end

  def self.down
    remove_column :press_lines, :press_filename_id
  end
end
