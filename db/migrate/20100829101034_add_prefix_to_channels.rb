class AddPrefixToChannels < ActiveRecord::Migration
  def self.up
      add_column :channels, :prefix, :string
  end

  def self.down
      remove_column :channels, :prefix
  end  
end
