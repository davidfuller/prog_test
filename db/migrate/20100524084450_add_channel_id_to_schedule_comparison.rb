class AddChannelIdToScheduleComparison < ActiveRecord::Migration

  def self.up
      add_column :schedule_comparisons, :channel_id, :integer
  end

  def self.down
      remove_column :schedule_comparisons, :channel_id
  end

end
