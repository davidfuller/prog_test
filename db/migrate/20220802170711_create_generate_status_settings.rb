class CreateGenerateStatusSettings < ActiveRecord::Migration
  def self.up
    create_table :generate_status_settings do |t|
      t.integer :channel_id
      t.boolean :enabled
      t.string :folder
      t.string :prefix

      t.timestamps
    end
  end

  def self.down
    drop_table :generate_status_settings
  end
end
