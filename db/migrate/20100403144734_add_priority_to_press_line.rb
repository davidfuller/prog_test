class AddPriorityToPressLine < ActiveRecord::Migration

  def self.up
    add_column :press_lines, :priority, :boolean
  end

  def self.down
    remove_column :press_lines, :priority
  end

end
