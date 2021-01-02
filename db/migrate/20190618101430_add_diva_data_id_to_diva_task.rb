class AddDivaDataIdToDivaTask < ActiveRecord::Migration
  def self.up
    add_column :diva_tasks, :diva_data_id, :integer
  end

  def self.down
    remove_column :diva_tasks, :diva_data_id
  end
end
