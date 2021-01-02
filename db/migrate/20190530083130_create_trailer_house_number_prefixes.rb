class CreateTrailerHouseNumberPrefixes < ActiveRecord::Migration
  def self.up
    create_table :trailer_house_number_prefixes do |t|
      t.string :prefix
      t.integer :language_id

      t.timestamps
    end
  end

  def self.down
    drop_table :trailer_house_number_prefixes
  end
end
