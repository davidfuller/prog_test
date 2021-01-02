class AddFieldNameToTrailerTabSetting < ActiveRecord::Migration
  def self.up
    add_column :trailer_tab_settings, :field_name, :string
  end

  def self.down
    remove_column :trailer_tab_settings, :field_name
  end
end
