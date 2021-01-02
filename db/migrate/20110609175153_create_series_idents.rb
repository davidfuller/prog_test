class CreateSeriesIdents < ActiveRecord::Migration
  def self.up
    create_table :series_idents do |t|
      t.string :number
      t.integer :title_id
      t.string :year_number
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :series_idents
  end
end
