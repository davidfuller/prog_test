class CreateChannelOnDemands < ActiveRecord::Migration
  def self.up
    create_table :channel_on_demands do |t|
      t.integer :channel_id
      t.integer :on_demand_id
      t.boolean :enable

      t.timestamps
    end
  end

  def self.down
    drop_table :channel_on_demands
  end
end
