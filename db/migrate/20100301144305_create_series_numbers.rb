class CreateSeriesNumbers < ActiveRecord::Migration
  def self.up
    create_table :series_numbers do |t|
      t.string :series_number
      t.integer :title_id

      t.timestamps
    end
  end

  def self.down
    drop_table :series_numbers
  end
end
