class AddTxTimeToPressLineAutomatedDynamicSpecialJoin < ActiveRecord::Migration
  def self.up
    add_column :press_line_automated_dynamic_special_joins, :tx_time, :datetime
  end

  def self.down
    remove_column :press_line_automated_dynamic_special_joins, :tx_time
  end
end
