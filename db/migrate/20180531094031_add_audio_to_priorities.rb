class AddAudioToPriorities < ActiveRecord::Migration
  def self.up
    add_column :priorities, :priority, :boolean
    add_column :priorities, :audio, :boolean
  end

  def self.down
    remove_column :priorities, :audio
    remove_column :priorities, :priority
  end
end
