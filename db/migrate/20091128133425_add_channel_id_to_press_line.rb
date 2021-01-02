class AddChannelIdToPressLine < ActiveRecord::Migration
  def self.up
    add_column :press_lines, :channel_id, :integer
  end

  def self.down
    remove_column :press_lines, :channel_id
  end
end
