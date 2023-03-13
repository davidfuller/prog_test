class CreateSportsIppStatuses < ActiveRecord::Migration
  def self.up
    create_table :sports_ipp_statuses do |t|
      t.integer :order
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :sports_ipp_statuses
  end
end
