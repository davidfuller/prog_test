class AddLogoToService < ActiveRecord::Migration
  def self.up
    add_column :services, :logo_filename, :string
  end

  def self.down
    remove_column :services, :logo_filename
  end
end
