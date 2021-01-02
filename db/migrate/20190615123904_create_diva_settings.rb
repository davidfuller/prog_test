class CreateDivaSettings < ActiveRecord::Migration
  def self.up
    create_table :diva_settings do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :diva_settings
  end
end
