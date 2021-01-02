class AddEopToTitles < ActiveRecord::Migration
  def self.up
    add_column :titles, :eop, :boolean
  end

  def self.down
    remove_column :titles, :eop
  end
end
