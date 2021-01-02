class CreateOnDemandFiles < ActiveRecord::Migration
  def self.up
    create_table :on_demand_files do |t|
      t.string :filename
      t.datetime :uploaded

      t.timestamps
    end
  end

  def self.down
    drop_table :on_demand_files
  end
end
