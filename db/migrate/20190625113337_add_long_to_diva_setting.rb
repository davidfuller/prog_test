class AddLongToDivaSetting < ActiveRecord::Migration
  def self.up
    add_column :diva_settings, :text_value, :text
  end

  def self.down
    remove_column :diva_settings, :text_value
  end
end
