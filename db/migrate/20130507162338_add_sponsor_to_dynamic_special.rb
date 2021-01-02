class AddSponsorToDynamicSpecial < ActiveRecord::Migration
  def self.up
    add_column :dynamic_specials, :sponsor, :string
    add_column :dynamic_specials, :sponsor_reference, :string
  end

  def self.down
    remove_column :dynamic_specials, :sponsor
    remove_column :dynamic_specials, :sponsor_reference
  end
end
