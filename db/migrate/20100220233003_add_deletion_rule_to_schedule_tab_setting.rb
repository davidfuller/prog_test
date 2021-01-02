class AddDeletionRuleToScheduleTabSetting < ActiveRecord::Migration
  def self.up
    add_column :schedule_tab_settings, :deletion_rule, :boolean
  end

  def self.down
    remove_column :schedule_tab_settings, :deletion_rule
  end
end
