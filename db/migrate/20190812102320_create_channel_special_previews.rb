class CreateChannelSpecialPreviews < ActiveRecord::Migration
  def self.up
    create_table :channel_special_previews do |t|
      t.integer :channel_id
      t.integer :special_preview_id
      t.boolean :enable

      t.timestamps
    end
  end

  def self.down
    drop_table :channel_special_previews
  end
end
