class Add43ToDynamicSpecial < ActiveRecord::Migration
  def self.up
    add_column :dynamic_specials, :page_43, :integer
    add_column :dynamic_specials, :clear_down_page_number_43, :integer
  end

  def self.down
    remove_column :dynamic_specials, :page_43
    remove_column :dynamic_specials, :clear_down_page_number_43
  end
end
