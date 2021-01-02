class AddSeriesIdentToCrossChannelPriorities < ActiveRecord::Migration
  def self.up
    add_column :cross_channel_priorities, :series_ident, :string
  end

  def self.down
    remove_column :cross_channel_priorities, :series_ident
  end
end
