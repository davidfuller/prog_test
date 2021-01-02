class AddSeriesNumberIdToHouses < ActiveRecord::Migration
  def self.up
    add_column :houses, :series_number_id, :integer
    remove_column :series_numbers, :title_id
  end

  def self.down
    remove_column :houses, :series_number_id
    add_column :series_numbers, :title_id, :integer
  end
end
