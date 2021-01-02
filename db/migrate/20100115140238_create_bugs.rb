class CreateBugs < ActiveRecord::Migration
  def self.up
    create_table :bugs do |t|
      t.string :name
      t.integer :page_number
      t.integer :channel_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bugs
  end
end
