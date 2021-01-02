class CreateCountdownIppsMediaFiles < ActiveRecord::Migration
  def self.up
    create_table :countdown_ipps_media_files, :id => false do |t|
      t.integer :countdown_ipp_id
      t.integer :media_file_id

      t.timestamps
    end
  end

  def self.down
    drop_table :countdown_ipps_media_files
  end
end
