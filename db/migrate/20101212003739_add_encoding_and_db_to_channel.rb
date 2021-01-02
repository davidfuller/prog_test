class AddEncodingAndDbToChannel < ActiveRecord::Migration
  def self.up
      add_column :channels, :encoding, :string
      add_column :channels, :has_dynamic_branding, :boolean
  end

  def self.down
      remove_column :channels, :encoding
      remove_column :channels, :has_dynamic_branding
  end
end
