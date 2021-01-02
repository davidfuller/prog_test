class AddEnableToTrailer < ActiveRecord::Migration
  def self.up
    add_column :trailers, :enable, :boolean
  end

  def self.down
    remove_column :trailers, :enable
  end
end
