class AddOrderToOnDemand < ActiveRecord::Migration
  def self.up
    add_column :on_demands, :order, :integer
    add_column :on_demands, :on_demand_file_id  , :integer
  end

  def self.down
    remove_column :on_demands, :order
    remove_column :on_demands, :on_demand_file_id
  end
end
