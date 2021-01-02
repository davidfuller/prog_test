class AddDescriptionToTitles < ActiveRecord::Migration
  def self.up
    add_column :titles, :description, :string
  end

  def self.down
    remove_column :titles, :description
  end
end
