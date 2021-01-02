class AddMediaIdToTrailers < ActiveRecord::Migration
  def self.up
    add_column :trailers, :media_file_id, :integer
  end

  def self.down
    remove_column :trailers, :media_file_id
  end
end
