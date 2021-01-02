class CreateDivaPolls < ActiveRecord::Migration
  def self.up
    create_table :diva_polls do |t|
      t.integer :media_search
      t.integer :workflow_start
      t.integer :workflow

      t.timestamps
    end
  end

  def self.down
    drop_table :diva_polls
  end
end
