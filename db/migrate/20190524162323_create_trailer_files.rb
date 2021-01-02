class CreateTrailerFiles < ActiveRecord::Migration
  def self.up
    create_table :trailer_files do |t|
      t.string :filename
      t.datetime :uploaded

      t.timestamps
    end
  end

  def self.down
    drop_table :trailer_files
  end
end
