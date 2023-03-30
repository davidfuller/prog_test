class AddFieldsToDynamicSpecialTemplates < ActiveRecord::Migration
  def self.up
    add_column :dynamic_special_templates, :ads, :boolean
    add_column :dynamic_special_templates, :sports_ipp, :boolean
  end

  def self.down
    remove_column :dynamic_special_templates, :sports_ipp
    remove_column :dynamic_special_templates, :ads
  end
end
