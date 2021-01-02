class CreateExceptionLists < ActiveRecord::Migration
  def self.up
    create_table :exception_lists do |t|
      t.datetime :entry_time
      t.string :channel_name
      t.string :original_title
      t.string :local_title
      t.string :clipsource_original_title
      t.string :clipsource_local_title
      t.string :eidr
      t.string :house_number

      t.timestamps
    end
  end

  def self.down
    drop_table :exception_lists
  end
end
