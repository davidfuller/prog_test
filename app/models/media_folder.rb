class MediaFolder < ActiveRecord::Base
  
  belongs_to :channel
  belongs_to :aspect
  has_many :media_files
  has_many :dynamic_special_image_specs
  
  
  def self.find_by_name_and_channel(name, channel)
    
    find( :first, 
          :conditions => ["name = ? AND channel_id = ?", name, channel.id] )
      
  end
  
end
