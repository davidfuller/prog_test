class PlaylistPositionSetting < ActiveRecord::Base
    
  validates_presence_of :item, :position, :length
  validates_uniqueness_of :position
  
  def self.sorted_position
    find(:all, :order => "position")
  end
  
  
  
end
