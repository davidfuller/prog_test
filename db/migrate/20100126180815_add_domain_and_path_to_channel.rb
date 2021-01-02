class AddDomainAndPathToChannel < ActiveRecord::Migration
  def self.up
      add_column :channels, :domain, :string
      add_column :channels, :path, :string
  end

  def self.down
    remove_column :channels, :domain
    remove_column :channels, :path
  end
end
