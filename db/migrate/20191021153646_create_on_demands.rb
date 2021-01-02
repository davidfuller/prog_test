class CreateOnDemands < ActiveRecord::Migration
  def self.up
    create_table :on_demands do |t|
      t.string :name
      t.string :title
      t.integer :service_id
      t.date :start_date
      t.date :end_date
      t.string :navigation
      t.string :message
      t.integer :priority
      t.boolean :ecp
      t.boolean :menu
      t.boolean :ipp

      t.timestamps
    end
  end

  def self.down
    drop_table :on_demands
  end
end
