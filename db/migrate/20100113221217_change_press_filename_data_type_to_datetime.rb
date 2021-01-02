class ChangePressFilenameDataTypeToDatetime < ActiveRecord::Migration
  def self.up
    change_column :press_filenames, :import_date, :datetime
  end

  def self.down
    change_column :press_filenames, :import_date, :date
  end
end
