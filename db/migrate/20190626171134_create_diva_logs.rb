class CreateDivaLogs < ActiveRecord::Migration
  def self.up
    create_table :diva_logs do |t|
      t.string :action
      t.integer :trailer_id
      t.string :uri
      t.text :xml_sent
      t.string :net_message
      t.text :xml_received
      t.string :filename
      t.string :data_message

      t.timestamps
    end
  end

  def self.down
    drop_table :diva_logs
  end
end
