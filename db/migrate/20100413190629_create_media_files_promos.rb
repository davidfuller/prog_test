class CreateMediaFilesPromos < ActiveRecord::Migration
  def self.up
    create_table :media_files_promos, :id => false do |t|
      t.integer :media_file_id
      t.integer :promo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :media_files_promos
  end
end
