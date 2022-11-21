class ScheduleFile < ActiveRecord::Base
  
  belongs_to :channel
  has_one :schedule_line  
  
  def base
    File.basename(name)
  end
  
  def self.display
    list = find(:all, :limit => 100, :order => 'created_at DESC').reverse
    files = []
    files << [['All'],'-1']
    
    list.each do |l|
      files << [[l.base], l.id.to_s]
    end
    files
  end

  
  def self.new_with_dates(filename, dates, channel)
    s = find_or_create_by_name(filename.to_s)
    s.channel = channel
    if dates[:found]
      s.start = dates[:start]
      s.end = dates [:stop]
    end
    s.save
    s
  end
  
  def self.last_entered
    last
  end
  
end
