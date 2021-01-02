class AddPromoIdToOnDemand < ActiveRecord::Migration
  def self.up
    add_column :on_demands, :promo_id, :integer
  end

  def self.down
    remove_column :on_demands, :promo_id
  end
end
