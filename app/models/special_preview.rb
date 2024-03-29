class SpecialPreview < ActiveRecord::Base

  belongs_to :media_file, :dependent => :destroy
  has_many :channel_special_previews, :dependent => :destroy
  has_many :channels, :through => :channel_special_previews
  has_one :automated_dynamic_special

  default_scope :order => :name

  validates_uniqueness_of :name, :message => " is already in the system"
  validates_presence_of :name

  require 'useful'

  def self.search(search, page, channel)
    last_use_date = Time.current.strftime('%F')
    if search 
      if channel == 'All'
        paginate  :per_page => 8, :page =>page,
                  :joins => :media_file,
                  :conditions => ['special_previews.name LIKE ? AND DATE(media_files.last_use) >= ?' , "%#{search}%", last_use_date]
      else
        paginate  :per_page => 8, :page =>page,
                  :joins => [:media_file, {:channels, :channel_special_previews}], :select => 'DISTINCT(special_previews.name), special_previews.*', 
                  :conditions =>['special_previews.name LIKE ? AND channels.name = ? AND channel_special_previews.enable = ? AND DATE(media_files.last_use) >= ?', "%#{search}%", channel, true, last_use_date]
      end
    else
      paginate  :all, :per_page => 8, :page =>page,
                :joins => :media_file,
                :conditions => ['DATE(media_files.last_use) >= ?' , last_use_date]
    end
  end 

  def add_media
    done = false
    if !self.media_file
      if link_or_create_media self
        message = 'Media added. '
        done = true
      else
        message = 'Media failed to be added. '
      end
    end
    {:success => done, :message => message}
  end

  def link_or_create_media(special_preview)
    media_filename = create_filename(special_preview.name, ".mov")
    media_file = MediaFile.find_by_filename(media_filename)
      
    if !media_file
      media_file = MediaFile.new
    end
    media_file.name = special_preview.name
    media_file.filename = media_filename
    media_file.has_audio = false
    media_file.first_use = Time.current
    media_file.last_use = Time.current + 3.months
    media_file.status = Status.find_by_value(0)
    media_file.media_folder = MediaFolder.find_by_name('Special Preview')
    media_file.media_type = MediaType.find_by_name('Special Preview')
    media_file.save
    special_preview.media_file = media_file
    special_preview.save
  end

  def create_filename(name, extension)
    Useful.strip_filename(name).upcase + extension
  end

  def add_any_channels_needed
    channels = Channel.language_scope
    channels.each do |c|
      logger.debug c.id
      if !self.channel_special_previews.find_by_channel_id(c.id)
        t = self.channel_special_previews.new
        t.channel_id = c.id
        t.save
      end
    end 
  end

  def add_automated_dynamic_special_channel(channel_id)
    channels = Channel.language_scope
    channels.each do |c|
      if !self.channel_special_previews.find_by_channel_id(c.id)
        t = self.channel_special_previews.new
        t.channel_id = c.id
        if c.id == channel_id
          t.enable = true
        else
          t.enable = false
        end
        t.save
      end
    end 
  end

  def channel_csv
    result = ''
    self.channel_special_previews.each do |c|
      if c.enable
        if result == ''
          result = c.channel.name
        else
          result += ', ' + c.channel.name
        end
      end
    end
    result
  end

  def self.new_name(ads_name)
    if find_by_name(ads_name)
      version = 1
      test_name = ads_name + "_" + "%03d" % version
      while find_by_name(test_name) && version < 999
        version += 1
        test_name = ads_name + "_" + "%03d" % version
      end
      test_name 
    else
      ads_name
    end
  end

  def self.recent(params)
    if params[:include_archive]
      paginate  :per_page => 5, :page =>params[:page], 
                :joins => [:media_file, :automated_dynamic_special], 
                :order => 'media_files.created_at DESC'
    else
      paginate  :per_page => 5, :page =>params[:page], 
                :joins => [:media_file, :automated_dynamic_special], :conditions => ['automated_dynamic_specials.archive = false'],
                :order => 'media_files.created_at DESC'
    end
  end
end
