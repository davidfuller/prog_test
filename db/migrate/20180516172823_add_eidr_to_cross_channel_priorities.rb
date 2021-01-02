class AddEidrToCrossChannelPriorities < ActiveRecord::Migration
  def self.up
    add_column :cross_channel_priorities, :eidr, :string
  end

  def self.down
    remove_column :cross_channel_priorities, :eidr
  end
end
