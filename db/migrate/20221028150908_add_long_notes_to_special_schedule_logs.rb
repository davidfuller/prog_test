class AddLongNotesToSpecialScheduleLogs < ActiveRecord::Migration
  def self.up
    add_column :special_schedule_logs, :long_notes, :longtext
  end

  def self.down
    remove_column :special_schedule_logs, :long_notes
  end
end
