class CreateSportsIppMedias < ActiveRecord::Migration
  def self.up
    create_table :sports_ipp_medias do |t|
      t.string :filename
      t.integer :sports_ipp_status_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sports_ipp_medias
  end
end
