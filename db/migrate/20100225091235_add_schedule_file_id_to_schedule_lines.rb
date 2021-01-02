class AddScheduleFileIdToScheduleLines < ActiveRecord::Migration
  def self.up
    add_column :schedule_lines, :schedule_file_id, :integer
  end

  def self.down
    remove_column :schedule_lines, :schedule_file_id
  end
end
