class AddTrailerFileIdToTrailer < ActiveRecord::Migration
  def self.up
    add_column :trailers, :trailer_file_id, :integer
  end

  def self.down
    remove_column :trailers, :trailer_file_id
  end
end
