class CreatePromosSeriesIdents < ActiveRecord::Migration
  def self.up
    create_table :promos_series_idents, :id => false do |t|
      t.integer :promo_id
      t.integer :series_ident_id

      t.timestamps
    end
  end

  def self.down
    drop_table :promos_series_idents
  end
end
