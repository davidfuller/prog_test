class AddPromoToDynamicSpecialImageSpec < ActiveRecord::Migration
  def self.up
    add_column :dynamic_special_image_specs, :promo, :boolean
  end

  def self.down
    remove_column :dynamic_special_image_specs, :promo
  end
end
