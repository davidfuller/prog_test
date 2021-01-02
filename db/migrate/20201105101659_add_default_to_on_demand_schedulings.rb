class AddDefaultToOnDemandSchedulings < ActiveRecord::Migration
  def self.up
    add_column :on_demand_schedulings, :default, :boolean
  end

  def self.down
    remove_column :on_demand_schedulings, :default
  end
end
