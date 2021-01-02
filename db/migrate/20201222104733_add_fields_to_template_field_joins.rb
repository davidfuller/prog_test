class AddFieldsToTemplateFieldJoins < ActiveRecord::Migration
  def self.up
    add_column :template_field_joins, :fixed, :boolean
    add_column :template_field_joins, :dropdown, :boolean
    add_column :template_field_joins, :default_value, :string
  end

  def self.down
    remove_column :template_field_joins, :default_value
    remove_column :template_field_joins, :dropdown
    remove_column :template_field_joins, :fixed
  end
end
