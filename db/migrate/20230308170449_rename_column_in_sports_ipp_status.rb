class RenameColumnInSportsIppStatus < ActiveRecord::Migration
  def self.up
    rename_column :sports_ipp_statuses, :order, :position
  end

  def self.down
    rename_column :sports_ipp_statuses, :position, :order
  end
end
