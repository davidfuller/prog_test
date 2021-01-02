class AddContentIdToPressLines < ActiveRecord::Migration
  def self.up
    add_column :press_lines, :content_id, :string
  end

  def self.down
    remove_column :press_lines, :content_id
  end
end
