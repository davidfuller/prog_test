class ChangeStartDateToDateTimeInOnDemand < ActiveRecord::Migration
  def self.up
    change_column :on_demands, :start_date, :datetime
    change_column :on_demands, :end_date, :datetime
  end

  def self.down
    change_column :on_demands, :start_date, :date
    change_column :on_demands, :end_date, :date
  end
end
