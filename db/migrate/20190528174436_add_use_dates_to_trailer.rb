class AddUseDatesToTrailer < ActiveRecord::Migration
  def self.up
    add_column :trailers, :first_use, :datetime
    add_column :trailers, :last_use, :datetime
  end

  def self.down
    remove_column :trailers, :last_use
    remove_column :trailers, :first_use
  end
end
