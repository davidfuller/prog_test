class CreatePressFilenames < ActiveRecord::Migration
  def self.up
    create_table :press_filenames do |t|
      t.string :filename
      t.date :import_date

      t.timestamps
    end
  end

  def self.down
    drop_table :press_filenames
  end
end
