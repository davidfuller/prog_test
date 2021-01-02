class AddAudioPriorityToPressLines < ActiveRecord::Migration
  def self.up
    add_column :press_lines, :audio_priority, :boolean
  end

  def self.down
    remove_column :press_lines, :audio_priority
  end
end
