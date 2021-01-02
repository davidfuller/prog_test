class AddCountryAndCodeToLanguage < ActiveRecord::Migration
  def self.up
    add_column :languages, :country, :string
    add_column :languages, :code, :string
  end

  def self.down
    remove_column :languages, :code
    remove_column :languages, :country
  end
end
