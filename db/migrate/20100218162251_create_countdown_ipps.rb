class CreateCountdownIpps < ActiveRecord::Migration
  def self.up
    create_table :countdown_ipps do |t|
      t.string :name
      t.integer :channel_id
      t.datetime :first_use
      t.datetime :last_use

      t.timestamps
    end
  end

  def self.down
    drop_table :countdown_ipps
  end
end
