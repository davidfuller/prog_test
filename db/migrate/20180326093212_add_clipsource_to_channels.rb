class AddClipsourceToChannels < ActiveRecord::Migration
  def self.up
    add_column :channels, :clipsource_domain, :string
    add_column :channels, :clipsource_path, :string
    add_column :channels, :clipsource_suffix, :string
  end

  def self.down
    remove_column :channels, :clipsource_suffix
    remove_column :channels, :clipsource_path
    remove_column :channels, :clipsource_domain
  end
end
