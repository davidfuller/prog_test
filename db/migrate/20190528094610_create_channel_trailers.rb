class CreateChannelTrailers < ActiveRecord::Migration
  def self.up
    create_table :channel_trailers do |t|
      t.integer :channel_id
      t.integer :trailer_id
      t.boolean :enable

      t.timestamps
    end
  end

  def self.down
    drop_table :channel_trailers
  end
end
