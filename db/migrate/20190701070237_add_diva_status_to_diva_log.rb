class AddDivaStatusToDivaLog < ActiveRecord::Migration
  def self.up
    add_column :diva_logs, :diva_status_id, :integer
  end

  def self.down
    remove_column :diva_logs, :diva_status_id
  end
end
