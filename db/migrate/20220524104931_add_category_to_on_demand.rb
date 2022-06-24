class AddCategoryToOnDemand < ActiveRecord::Migration
  def self.up
    add_column :on_demands, :category, :string
  end

  def self.down
    remove_column :on_demands, :category
  end
end
