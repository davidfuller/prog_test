class AddFieldsToDivaStatus < ActiveRecord::Migration
  def self.up
    add_column :diva_statuses, :css, :string
    add_column :diva_statuses, :description, :text
  end

  def self.down
    remove_column :diva_statuses, :description
    remove_column :diva_statuses, :css
  end
end
