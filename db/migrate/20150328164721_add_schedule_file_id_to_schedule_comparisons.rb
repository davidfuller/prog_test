class AddScheduleFileIdToScheduleComparisons < ActiveRecord::Migration
  def self.up
    add_column :schedule_comparisons, :schedule_file_id, :integer
  end

  def self.down
    remove_column :schedule_comparisons, :schedule_file_id
  end
end
