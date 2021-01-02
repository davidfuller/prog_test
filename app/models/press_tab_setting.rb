class PressTabSetting < ActiveRecord::Base
  
  validates_presence_of :item, :position
  validates_uniqueness_of :position
  
  def self.sorted_tabs
    find(:all, :order => "clipsource_position")
  end
  
  
end
