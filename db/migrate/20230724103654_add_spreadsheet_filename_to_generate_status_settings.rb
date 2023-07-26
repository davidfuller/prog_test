class AddSpreadsheetFilenameToGenerateStatusSettings < ActiveRecord::Migration
  def self.up
    add_column :generate_status_settings, :spreadsheet_filename, :string
  end

  def self.down
    remove_column :generate_status_settings, :spreadsheet_filename
  end
end
