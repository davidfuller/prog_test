class CreateTrailers < ActiveRecord::Migration
  def self.up
    create_table :trailers do |t|
      t.string :house_number
      t.string :title
      t.datetime :change
      t.string :channels
      t.string :ingest_status
      t.integer :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :trailers
  end
end
