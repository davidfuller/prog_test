class AddEidrToSeriesIdents < ActiveRecord::Migration
  def self.up
    add_column :series_idents, :eidr, :string
  end

  def self.down
    remove_column :series_idents, :eidr
  end
end
