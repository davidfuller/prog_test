class CreateDivaStatuses < ActiveRecord::Migration
  def self.up
    create_table :diva_statuses do |t|
      t.integer :value
      t.string :message
      t.boolean :seach
      t.boolean :workflow

      t.timestamps
    end
  end

  def self.down
    drop_table :diva_statuses
  end
end
