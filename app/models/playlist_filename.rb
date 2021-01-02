class PlaylistFilename < ActiveRecord::Base
  
  has_one :playlist_line
  belongs_to :channel
  
  def base
    File.basename(filename)
  end
  
  
  def self.display
#    all(:select => :filename).map{|m| m.base}
    list = all
    files = []
    
    list.each do |l|
      files << [[l.base], l.id.to_s]
    end
    files
  end
  
  def self.last_entered
    last
  end
  
end
