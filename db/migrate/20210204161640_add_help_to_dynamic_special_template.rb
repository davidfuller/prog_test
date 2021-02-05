class AddHelpToDynamicSpecialTemplate < ActiveRecord::Migration
  def self.up
    add_column :dynamic_special_templates, :help_message, :string
  end

  def self.down
    remove_column :dynamic_special_templates, :help_message
  end
end
