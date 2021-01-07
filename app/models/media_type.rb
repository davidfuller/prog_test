class MediaType < ActiveRecord::Base
  
  has_many :media_files
  default_scope :order => :name
  
  def self.special_media
    find_by_name('Special Media')
  end
  
  def self.media_type_display

    display = ['All']
    all.each do |type|
      display << [type.name]
    end
    display
  end
  
  def self.clips_and_stills
    display = []
    all.each do |type|
      display << [type.name] unless type.name == 'Countdown IPP'
    end
    display
  end
end
