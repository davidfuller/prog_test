class CreateSportsIpps < ActiveRecord::Migration
  def self.up
    create_table :sports_ipps do |t|
      t.string :name
      t.integer :media_file_id
      t.integer :sports_ipp_media_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sports_ipps
  end
end
