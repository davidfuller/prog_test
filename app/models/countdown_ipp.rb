class CountdownIpp < ActiveRecord::Base
  
  belongs_to :channel
  has_and_belongs_to_many :media_files
  
  def add_file(media_file)
    media_files << media_file
  end
     
  def self.new_with_default_times
    ipp = CountdownIpp.new
    ipp.first_use = Date.today.to_datetime.advance(:hours => 6)
    ipp.last_use = ipp.first_use.advance(:days => 7, :hours => 14)
    ipp
  end
  
  def self.search(search, countdown_date, channel)
    channel_id = Channel.find_by_name(channel)
    if channel_id
      if search
        if countdown_date.blank? then
          find(:all, :conditions => ['name LIKE ? and channel_id = ?', "%#{search}%", channel_id], :order => :last_use)
        else
          date = Date.parse(countdown_date).strftime('%F')
          find(:all, :conditions => ['name LIKE ? and DATE(last_use) >= ? and channel_id = ?', "%#{search}%", date, channel_id], :order => :last_use)
        end
      else
        if countdown_date.blank? then
          find(:all,:conditions => ['channel_id = ?', channel_id], :order => :last_use)
        else
          date = Date.parse(countdown_date).strftime('%F')
          find(:all, :conditions => ['DATE(last_use) >= ? and channel_id = ?', date, channel_id], :order => :last_use)
        end
      end
    else
      if search
        if countdown_date.blank? then
          find(:all, :conditions => ['name LIKE ?', "%#{search}%"], :order => :last_use)
        else
          date = Date.parse(countdown_date).strftime('%F')
          find(:all, :conditions => ['name LIKE ? and DATE(last_use) >= ?', "%#{search}%", date], :order => :last_use)
        end
      else
        if countdown_date.blank? then
          find(:all, :order => :last_use)
        else
          date = Date.parse(countdown_date).strftime('%F')
          find(:all, :conditions => ['DATE(last_use) >= ?', date], :order => :last_use)
        end
      end
    end
  end 

  
end
