class AddOrderToGenerateStatusSetting < ActiveRecord::Migration
  def self.up
    add_column :generate_status_settings, :channel_order, :integer
  end

  def self.down
    remove_column :generate_status_settings, :channel_order
  end
end
