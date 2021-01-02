class AddCountryCodeToLanguage < ActiveRecord::Migration
  def self.up
    add_column :on_demands, :country_code, :string
  end

  def self.down
    remove_column :on_demands, :country_code
  end
end
