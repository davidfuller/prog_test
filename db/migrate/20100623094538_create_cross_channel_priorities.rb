class CreateCrossChannelPriorities < ActiveRecord::Migration
  def self.up
    create_table :cross_channel_priorities do |t|
      t.datetime :billed
      t.string :original_title
      t.string :local_title
      t.string :lead_text
      t.integer :channel_id
      t.integer :tx_channel_id
      t.integer :press_id
      t.integer :title_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cross_channel_priorities
  end
end
