class AddFilenameToGenerateStatusSettings < ActiveRecord::Migration
  def self.up
    add_column :generate_status_settings, :filename, :string
  end

  def self.down
    remove_column :generate_status_settings, :filename
  end
end
