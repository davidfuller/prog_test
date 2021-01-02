class ChangeChannelsColumnNameTrailers < ActiveRecord::Migration
  def self.up
		rename_column :trailers, :channels, :channels_text	
  end

  def self.down
		rename_column :trailers, :channels_text, :channels
  end
end
