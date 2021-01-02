class AddSchedulingToOnDemands < ActiveRecord::Migration
  def self.up
    add_column :on_demands, :on_demand_scheduling_id, :integer
  end

  def self.down
    remove_column :on_demands, :on_demand_scheduling_id
  end
end
