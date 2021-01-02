class AddBssNameToChannels < ActiveRecord::Migration
  def self.up
    add_column :channels, :bss_name, :string
  end

  def self.down
    remove_column :channels, :bss_name
  end
end
