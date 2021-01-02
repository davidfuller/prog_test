class AddEidrToScheduleComparisons < ActiveRecord::Migration
  def self.up
    add_column :schedule_comparisons, :eidr, :string
  end

  def self.down
    remove_column :schedule_comparisons, :eidr
  end
end
