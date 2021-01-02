class AddChannelIdToComparison < ActiveRecord::Migration
  def self.up
      add_column :comparisons, :channel_id, :integer
  end

  def self.down
      remove_column :comparisons, :channel_id
  end
end
