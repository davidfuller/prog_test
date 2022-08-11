class CreateGenerateStatusLines < ActiveRecord::Migration
  def self.up
    create_table :generate_status_lines do |t|
      t.integer :channel_id
      t.string :full_filename
      t.string :short_filename
      t.date :tx_date
      t.string :tx_version
      t.datetime :generate_date_time
      t.string :status
      t.datetime :poll_date_time
      t.datetime :file_modified_date_time

      t.timestamps
    end
  end

  def self.down
    drop_table :generate_status_lines
  end
end
