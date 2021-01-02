class AddLeadTextToPressLine < ActiveRecord::Migration
  def self.up
    add_column :press_lines, :lead_text, :string
  end

  def self.down
    remove_column :press_lines, :lead_text
  end

end
