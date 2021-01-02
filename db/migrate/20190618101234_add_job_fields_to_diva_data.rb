class AddJobFieldsToDivaData < ActiveRecord::Migration
  def self.up
    add_column :diva_datas, :job_id, :integer
    add_column :diva_datas, :status, :string
    add_column :diva_datas, :job_created, :datetime
    add_column :diva_datas, :job_started, :datetime
    add_column :diva_datas, :job_completed, :datetime
  end

  def self.down
    remove_column :diva_datas, :job_completed
    remove_column :diva_datas, :job_started
    remove_column :diva_datas, :job_created
    remove_column :diva_datas, :status
    remove_column :diva_datas, :job_id
  end
end
