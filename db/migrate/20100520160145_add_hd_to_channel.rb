class AddHdToChannel < ActiveRecord::Migration

  def self.up
      add_column :channels, :hd, :boolean
  end

  def self.down
      remove_column :channels, :hd
  end
end
