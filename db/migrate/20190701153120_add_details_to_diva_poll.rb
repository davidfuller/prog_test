class AddDetailsToDivaPoll < ActiveRecord::Migration
  def self.up
    add_column :diva_polls, :media_details, :text
    add_column :diva_polls, :workflow_start_details, :text
    add_column :diva_polls, :workflow_details, :text
  end

  def self.down
    remove_column :diva_polls, :workflow_details
    remove_column :diva_polls, :workflow_start_details
    remove_column :diva_polls, :media_details
  end
end
