class Channel < ActiveRecord::Base
  
  belongs_to :language
  has_many :press_lines
  has_many :bugs
  has_many :media_folders
  has_many :countdown_ipps
  has_many :schedule_files
  has_many :schedule_comparisons
  has_many :playlist_filenames
  has_many :comparisons
  has_many :cross_channel_priorities
  has_many :channel_trailers
  has_many :trailers, :through => :channel_trailers
  has_many :on_demands, :through => :channel_on_demands
  has_many :channel_special_previews
  has_many :special_previews, :through => :channel_special_previews
  has_many :automated_dynamic_specials
  has_many :generate_status_settings
  has_many :generate_status_settings

  validates_presence_of :name, :language_id
  default_scope :order => :name
  named_scope :language_scope, :order => "language_id, name"
  
  
  def self.display
    all(:select => :name).map{|m| m.name}
  end
  
  def hd_display
    if hd
      "HD"
    else
      "SD"
    end
  end
  
  def self.press_channel_from_filename(filename)
    @channels = find(:all, :order => :name)
    logger.debug filename.inspect
    channel_name = 'Please select'
    @channels.each do |c|
      l = c.press_code.length
      if l > 0
        if filename.include? c.press_code
          channel_name = c.name
        end
      end
    end
    channel_name
  end
  
  
  def self.filename (channel, press_date)
    week = press_date.strftime('%V')
    year = press_date.strftime('%G')
#    channel.press_code + "_" + year + "-" + ("%02d" % week) + "_tab.txt"
    channel.press_code + "_" + year + "-" + week + "_tab.txt"
  end

  def self.clipsource_filename(channel, press_date, xml_file)
  # makes array for week, starting the monday of press_date
    this_monday = press_date.monday
    filenames = []
    for i in 0..6
      this_date = this_monday + i.days
      if xml_file
        filenames << channel.press_code + "_" + this_date.strftime('%Y-%m-%d') + ".xml"
      else
        filenames << channel.press_code + "_" + this_date.strftime('%Y-%m-%d') + "_tab.txt"
      end
    end

    filenames
    
  end
    
  def self.clipsource_url_suffix (channel, press_date, xml_file)
  # makes array for week, starting the monday of press_date
    this_monday = press_date.monday
    suffixes = []
    for i in 0..6
      this_date = this_monday + i.days
      if xml_file
        suffixes << '&date=' + this_date.strftime('%Y-%m-%d') + '&channelId=' + channel.clipsource_suffix
      else
        suffixes << '&date=' + this_date.strftime('%Y-%m-%d') + '&channelId=' + channel.clipsource_suffix + "&format=tab"
      end
    end
    
    suffixes
    
  end
  
  def self.encodings
    ["ISO-8859-1","UTF-8","WINDOWS-1250","WINDOWS-1251","WINDOWS-1252"]
  end
  
  def self.channel_language_name(channel_name)
    find_by_name(channel_name).language.name
  end  

  def self.channel_display_with_all
    list = Channel.language_scope.find(:all, :select =>:name).map{|m| m.name}
    list.unshift('All')
  end
  
  
end
