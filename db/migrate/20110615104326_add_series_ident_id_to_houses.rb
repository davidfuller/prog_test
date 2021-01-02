class AddSeriesIdentIdToHouses < ActiveRecord::Migration
  def self.up
    add_column :houses, :series_ident_id, :integer
  end

  def self.down
    remove_column :houses, :series_ident_id
  end
end
