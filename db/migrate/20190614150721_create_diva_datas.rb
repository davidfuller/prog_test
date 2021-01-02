class CreateDivaDatas < ActiveRecord::Migration
  def self.up
    create_table :diva_datas do |t|
      t.string :system_id
      t.string :diva_house_number
      t.integer :diva_duration
      t.string :tv_standard
      t.integer :diva_status_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :diva_datas
  end
end
