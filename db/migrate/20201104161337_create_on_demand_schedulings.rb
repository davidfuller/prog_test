class CreateOnDemandSchedulings < ActiveRecord::Migration
  def self.up
    create_table :on_demand_schedulings do |t|
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :on_demand_schedulings
  end
end
