class ChangeMaterialIdToHouseNo < ActiveRecord::Migration
  def self.up
    rename_column :playlist_lines, :material_id, :house_no
  end

  def self.down
        rename_column :playlist_lines, :house_no, :material_id
  end
end
