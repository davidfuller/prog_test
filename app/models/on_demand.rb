class OnDemand < ActiveRecord::Base
  
  require 'csv'

  has_many :channel_on_demands, :dependent => :destroy
  has_many :channels, :through => :channel_on_demands
  belongs_to :service
  belongs_to :on_demand_file
  belongs_to :promo
  belongs_to :on_demand_scheduling

  default_scope :order => "name"


  PER_PAGE = 12
  IGNORE = [:id, :updated_at, :created_at, :on_demand_file_id, :promo_id]

  def self.search(search, page, filename_id, use_date, channel, show_all, no_media)

    logger.debug filename_id
    logger.debug filename_id.nil?

    if use_date && use_date != ''
      use_date_time = Date.parse(use_date) + 12.hours

      if channel == 'All'|| channel.nil?
        if filename_id.nil? || filename_id == '-1'
          if no_media
            paginate  :per_page => PER_PAGE, :page =>page,
                      :conditions => ['(title LIKE ? OR name LIKE ?) AND start_date <= ? AND end_date >= ? AND promo_id IS NULL', "%#{search}%", "%#{search}%", use_date_time, use_date_time]
          else
            paginate  :per_page => PER_PAGE, :page =>page,
                      :conditions => ['(title LIKE ? OR name LIKE ?) AND start_date <= ? AND end_date >= ?', "%#{search}%", "%#{search}%", use_date_time, use_date_time]
          end
        else
          if no_media
            paginate  :per_page => PER_PAGE, :page =>page,
                      :conditions => ['(title LIKE ? OR name LIKE ?) AND start_date <= ? AND end_date >= ? AND on_demand_file_id = ? AND promo_id IS NULL', "%#{search}%", "%#{search}%", use_date_time, use_date_time, filename_id]
          else
            paginate  :per_page => PER_PAGE, :page =>page,
                      :conditions => ['(title LIKE ? OR name LIKE ?) AND start_date <= ? AND end_date >= ?', "%#{search}%", "%#{search}%", use_date_time, use_date_time]
          end
        end
      else
        if filename_id.nil? || filename_id == '-1'
          if no_media
            paginate  :per_page => PER_PAGE, :page =>page,
                      :joins => [:channels, :channel_on_demands], :select => 'DISTINCT(on_demands.title), on_demands.*',
                      :conditions => ['(title LIKE ? OR on_demands.name LIKE ?) AND start_date <= ? AND end_date >= ? AND channels.name = ? AND channel_on_demands.enable = ? AND promo_id IS NULL', "%#{search}%", "%#{search}%", use_date_time, use_date_time, channel, true]
          else
            paginate  :per_page => PER_PAGE, :page =>page,
                      :joins => [:channels, :channel_on_demands], :select => 'DISTINCT(on_demands.title), on_demands.*',
                      :conditions => ['(title LIKE ? OR on_demands.name LIKE ?) AND start_date <= ? AND end_date >= ? AND channels.name = ? AND channel_on_demands.enable = ?', "%#{search}%", "%#{search}%", use_date_time, use_date_time, channel, true]
          end
        else
          if no_media
            paginate  :per_page => PER_PAGE, :page =>page,
                      :joins => [:channels, :channel_on_demands], :select => 'DISTINCT(on_demands.title), on_demands.*',
                      :conditions => ['(title LIKE ? OR on_demands.name LIKE ?) AND start_date <= ? AND end_date >= ? AND on_demand_file_id = ? AND channels.name = ? AND channel_on_demands.enable = ? AND promo_id IS NULL', "%#{search}%", "%#{search}%", use_date_time, use_date_time, filename_id, channel, true]
          else
            paginate  :per_page => PER_PAGE, :page =>page,
                      :joins => [:channels, :channel_on_demands], :select => 'DISTINCT(on_demands.title), on_demands.*',
                      :conditions => ['(title LIKE ? OR on_demands.name LIKE ?) AND start_date <= ? AND end_date >= ? AND on_demand_file_id = ? AND channels.name = ? AND channel_on_demands.enable = ?', "%#{search}%", "%#{search}%", use_date_time, use_date_time, filename_id, channel, true]
          end
        end
      end
    else
      if show_all
        end_date_time = Date.new(1960,2,11)
      else
        end_date_time = Date.current + 12.hours
      end 
      
      if channel == 'All' || channel.nil?
        if filename_id.nil? || filename_id == '-1'
          if no_media
            paginate  :per_page => PER_PAGE, :page => page,
                      :conditions => ['(title LIKE ? OR name LIKE ?) AND end_date >= ? AND promo_id IS NULL', "%#{search}%", "%#{search}%", end_date_time]
          else
            paginate  :per_page => PER_PAGE, :page => page,
                      :conditions => ['(title LIKE ? OR name LIKE ?) AND end_date >= ?', "%#{search}%", "%#{search}%", end_date_time]
          end
        else
          if no_media
            paginate  :per_page => PER_PAGE, :page => page,
                      :conditions => ['(title LIKE ? OR name LIKE ?) AND on_demand_file_id = ? AND end_date >= ? AND promo_id IS NULL', "%#{search}%", "%#{search}%", filename_id, end_date_time]
          else
            paginate  :per_page => PER_PAGE, :page => page,
                      :conditions => ['(title LIKE ? OR name LIKE ?) AND on_demand_file_id = ? AND end_date >= ?', "%#{search}%", "%#{search}%", filename_id, end_date_time]
          end
        end
      else
        if filename_id.nil? || filename_id == '-1'
          if no_media
            paginate  :per_page => PER_PAGE, :page => page,
                      :joins => [:channels, :channel_on_demands], :select => 'DISTINCT(on_demands.title), on_demands.*',
                      :conditions => ['(title LIKE ? OR on_demands.name LIKE ?) AND channels.name = ? AND channel_on_demands.enable = ? AND end_date >= ? AND promo_id IS NULL', "%#{search}%", "%#{search}%", channel, true, end_date_time]
          else
            paginate  :per_page => PER_PAGE, :page => page,
                      :joins => [:channels, :channel_on_demands], :select => 'DISTINCT(on_demands.title), on_demands.*',
                      :conditions => ['(title LIKE ? OR on_demands.name LIKE ?) AND channels.name = ? AND channel_on_demands.enable = ? AND end_date >= ?', "%#{search}%", "%#{search}%", channel, true, end_date_time]
          end
        else
          if no_media
            paginate  :per_page => PER_PAGE, :page =>page,
                      :joins => [:channels, :channel_on_demands], :select => 'DISTINCT(on_demands.title), on_demands.*',
                      :conditions => ['(title LIKE ? OR on_demands.name LIKE ?) AND on_demand_file_id = ? AND channels.name = ? AND channel_on_demands.enable = ? AND end_date >= ? AND promo_id IS NULL', "%#{search}%", "%#{search}%", filename_id, channel, true, end_date_time]
          else
            paginate  :per_page => PER_PAGE, :page =>page,
                      :joins => [:channels, :channel_on_demands], :select => 'DISTINCT(on_demands.title), on_demands.*',
                      :conditions => ['(title LIKE ? OR on_demands.name LIKE ?) AND on_demand_file_id = ? AND channels.name = ? AND channel_on_demands.enable = ? AND end_date >= ?', "%#{search}%", "%#{search}%", filename_id, channel, true, end_date_time]
          end
        end
      end
    end
  end

  def self.filter_for_xml(end_date, channel)
    if end_date && end_date != ''
      end_date_time = Date.parse(end_date) + 12.hours
    else
      end_date_time = Date.new(1960,2,11)
    end
    if channel.nil?
        find(:all, :conditions => ['end_date >= ?', end_date_time])
    else
        find(:all, :joins => [:channels, :channel_on_demands], :select => 'DISTINCT(on_demands.title), on_demands.*',
                  :conditions => ['end_date >= ? AND channels.name = ? AND channel_on_demands.enable = ?', end_date_time, channel, true])
    end
  end

  def create_promo
    name = self.name
    base_name = name
    issues = 0
    notice = ''
    counter = 0
    loop do
      p = Promo.find_by_name(name)
      
      if p.nil?
        break
      end
      if counter == 0
        if self.service
          base_name = name + '-' + service.name 
          name = base_name
        else
          base_name = name
          name = base_name + '-00'
        end
      else
        name =  base_name + '-' + "%02d" % counter
      end
      counter += 1
      if counter > 99
        issues += 1
        notice += 'Exceeded maximum promo names: ' + name
        break
      end  
    end
    if issues == 0
      p = Promo.new
      p.name = name
      p.first_use = self.start_date
      six_months = p.first_use.advance(:months => 6)
      if self.end_date > six_months
        p.last_use = self.end_date
      else
        p.last_use = six_months
      end
      if p.save
        notice += 'Promo created. '
        media = MediaFile.create_media(p,'portrait', p.first_use, p.last_use)
        if media then
          notice += 'Portait media created. '
        end
        self.promo_id = p.id
        if self.save
          notice += 'Promo added to On Demand item. '
        else
          self.errors.each do |e|
            notice += e.to_s.capitalize + ". "
            issues += 1
          end
        end  
      else
        p.errors.each do |e|
          notice += e.to_s.capitalize + ". "
          issues += 1
        end
      end
    end
    
    {:promo_id => p.id, :notice => notice, issues => issues}
  end
    
  def ecp_display
    if ecp
      'ECP'
    else
      ''
    end
  end
  
  def menu_display
    if menu
      'Menu'
    else
      ''
    end
  end
  def ipp_display
    if ipp
      'IPP'
    else
      ''
    end
  end

  def device_display
    message = ''
    if ecp
      message = "ECP "
    end
    if menu
      message += "Menu "
    end
    if ipp
      message += "IPP"
    end
    message.strip
  end

  def has_portrait_media_display
    if has_portrait_media
      'Media'
    else
      ''
    end
  end

  def has_portrait_media
    promo && promo.portrait_media_files && promo.portrait_media_files.count > 0
  end

  def scheduling_message
    if on_demand_scheduling_id
      on_demand_scheduling.message
    else
      OnDemandScheduling.find_by_default(true).message
    end
  end

  def self.import(filename)

    file_basename = File.basename(filename)
    via_filename = OnDemandFile.find_by_filename(file_basename)
    if !via_filename
      via_filename = OnDemandFile.new
      via_filename.filename = file_basename
    end
    
    via_filename.uploaded = Time.current
    if via_filename.save
      file_id = via_filename.id
      logger.debug file_id
    end

    csv_text = File.read(filename)
    process_csv(csv_text, file_id)
  end

  def self.process_csv(str, file_id)
    csv = CSV.parse(str)
    headers = get_headers(csv[0])
    num_processed = 0
    num_rows = 0
    num_empty = 0
    num_exists = 0
    num_not_saved = 0
    num_updated = 0
    message = ''
    csv.each_with_index do |row, index|
      if index > 0
        data = {}
        headers.each_with_index do |item, i|
          data[headers[i]] = row[i]
        end
        num_rows += 1
        status = process_row(data, file_id)
        if status[:result] == :saved
          num_processed += 1
        elsif status[:result] == :invalid_row
          num_empty += 1
        elsif status[:result] == :exists
          num_exists += 1
        elsif status[:result] == :updated
          num_updated += 1
        else
          num_not_saved += 1
        end
        if status[:message]
          message += status[:message]
        end
      end
    end
    { :rows => num_rows, :processed => num_processed, :empty => num_empty, :num_exists => num_exists, :num_not_saved => num_not_saved, :num_updated => num_updated , :message => message}
  end

  def self.test_already_exists(od)
    updatable(od)
  end

  def add_any_channels_needed
    channels = Channel.language_scope
    channels.each do |c|
      logger.debug c.id
      if !self.channel_on_demands.find_by_channel_id(c.id)
        t = self.channel_on_demands.new
        t.channel_id = c.id
        t.save
      end
    end 
  end

  def channel_csv
    result = ''
    self.channel_on_demands.each do |c|
      if c.enable
        if result == ''
          result = c.channel.prefix
        else
          result += ', ' + c.channel.prefix
        end
      end
    end
    result
  end

  def end_date_date_only
    if end_date?
      end_date - 1.days
    end
  end

  private

  def self.get_headers(csv_top_row)
    csv_top_row
  end

  def self.five_am_datetime(date_string, offset_days)
    
    begin
      DateTime.strptime(date_string, "%d/%m/%Y") + 5.hours + offset_days.days if date_string  
    rescue => exception
      nil
    end
    
  end

  def self.text_to_boolean(text)
    if text.nil?
      false
    elsif text == ''
      false
    elsif text.downcase == 'n'
      false
    else
      true
    end
  end

  def self.process_row(row, file_id)
    name = row['Name']
    title = row['Promoted Programme']
    message = ''
    if name && title
      od = self.new
      od.order = row['Order'].to_i
      od.name = name
      logger.debug "-=-=-=-=-=-=-=--"
      logger.debug od.name
      od.title = title
      od.country_code = country_code_from_row(row)
      od.service = Service.find_by_name(row['OD Service'])
      od.on_demand_file_id = file_id
      od.start_date = five_am_datetime(row['Start Date'], 0)
      if od.start_date
        od.end_date = five_am_datetime(row['End Date'], 1)
        if od.end_date
          od.navigation = row['Navigation Message']
          od.message = row['Promotional Message']
          od.priority = row['Priority'].to_i
          od.ecp = text_to_boolean(row['ECP'])
          od.menu = text_to_boolean(row['Menu'])
          od.ipp = text_to_boolean(row['IPP'])
          logger.debug "-=-=-=-=-=-=-=--2"
          od.on_demand_scheduling = OnDemandScheduling.find_by_message(row['Scheduling'])
          logger.debug od.on_demand_scheduling_id
          if already_exists(od)
            logger.debug "Exists"
            logger.debug od.name
            result = :exists
          else
            current = self.updatable(od)
            if current
              logger.debug "Updatable"
              logger.debug od.name
              current_start = current.start_date
              current_end = current.end_date
              current_promo_id = current.promo_id
              current.update_attributes(od.attributes)
              current.promo_id = current_promo_id
              if current_start < current.start_date
                current.start_date = current_start
              elsif current_start > current.start_date
                message += od.name + " has had it's start date changed from: " + current_start.to_s(:broadcast_date) + " to " + current.start_date.to_s(:broadcast_date) + ". "
              end
              if current_end > current.end_date
                current.end_date = current_end
              elsif current_end < current.end_date
                message += od.name + " has had it's end date changed from: " + current_end.to_s(:broadcast_date) + " to " + current.end_date.to_s(:broadcast_date) + ". "
              end
              current.save
              od = current
              result = :updated
            else
              if od.save
                result = :saved
              else
                result = :not_saved
              end
            end
          end
        else
          result = :invalid_row
        end
      else
        result = :invalid_row
      end

      if result == :exists || result == :updated || result == :saved
        logger.debug "Channel==========="
        od.add_any_channels_needed
        channel_ids = channels_from_row(row)
        logger.debug channel_ids
        channel_ids.each do |channel_id|
          t = od.channel_on_demands.find_by_channel_id(channel_id)
          logger.debug "I am here"
          logger.debug t
          if t
            logger.debug "Channel==========="
            logger.debug t
            t.enable = true
            t.save
          end
        end
      end
      { :result => result, :message => message }
    else
      { :result => :invalid_row }
    end
  end

  def self.already_exists(od)
    current = find_all_by_name_and_title(od.name, od.title)
    result = false
    current.each do |test|
      if test.attributes.except(*IGNORE.map(&:to_s)) == od.attributes.except(*IGNORE.map(&:to_s))
        result = true
      end
    end
    result
  end

  def self.updatable(od)
    current = find_all_by_name_and_title_and_service_id_and_country_code(od.name, od.title, od.service_id, od.country_code)
    if current.size == 1
      current.first
    else
      nil
    end
  end

  def self.channels_from_row(row)
    channel_ids = []
    if text_to_boolean(row['TV3S'])
      channel = Channel.find_by_name('TV3 Sweden')
      channel_ids << channel.id if channel
    end
    if text_to_boolean(row['TV6S'])
      channel = Channel.find_by_name('TV6 Sweden')
      channel_ids << channel.id if channel
    end
    if text_to_boolean(row['TV8S'])
      channel = Channel.find_by_name('TV8 Sweden')
      channel_ids << channel.id if channel
    end
    if text_to_boolean(row['TV10S'])
      channel = Channel.find_by_name('TV10 Sweden')
      channel_ids << channel.id if channel
    end
    if text_to_boolean(row['TV3D'])
      channel = Channel.find_by_name('TV3D')
      channel_ids << channel.id if channel
    end
    if text_to_boolean(row['TV3+'])
      channel = Channel.find_by_name('TV3+')
      channel_ids << channel.id if channel
    end
    if text_to_boolean(row['Puls'])
      channel = Channel.find_by_name('Puls')
      channel_ids << channel.id if channel
    end
    if text_to_boolean(row['TV3N'])
      channel = Channel.find_by_name('TV3N')
      channel_ids << channel.id if channel
    end
    if text_to_boolean(row['TV6N'])
      channel = Channel.find_by_name('TV6 Norway')
      channel_ids << channel.id if channel
    end
    if text_to_boolean(row['V4N'])
      channel = Channel.find_by_name('V4')
      channel_ids << channel.id if channel
    end
    channel_ids
  end

  def self.country_code_from_row(row)
    ids = channels_from_row(row)
    if ids.length > 0
      channel = Channel.find(ids.first)
      if channel
        code = channel.language.code if channel.language
      end
    end
    if code 
      code
    else
      ''
    end
  end
end
