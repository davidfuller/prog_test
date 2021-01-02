class AddEidrToPressLine < ActiveRecord::Migration
  def self.up
    add_column :press_lines, :eidr, :string
  end

  def self.down
    remove_column :press_lines, :eidr
  end
end
