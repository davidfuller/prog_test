class AddDivaDataIdToTrailers < ActiveRecord::Migration
  def self.up
    add_column :trailers, :diva_data_id, :integer
  end

  def self.down
    remove_column :trailers, :diva_data_id
  end
end
