class Trailer < ActiveRecord::Base

  has_many :channel_trailers, :dependent => :destroy
  has_many :channels, :through => :channel_trailers
  belongs_to :trailer_file
  belongs_to :media_file, :dependent => :destroy
  belongs_to :diva_data, :dependent => :destroy
  has_many :diva_logs

  default_scope :order => :title

  before_validation :check_enabled

  validates_uniqueness_of :house_number, :message => " is already in the system"
  validates_presence_of :title, :house_number

  require 'useful'
  
  def self.search(search, page, filename_id, use_date, show_choice)

    if show_choice == '3'
      paginate requires_diva_data, :per_page => 12, :page => page
    elsif show_choice == '4'
      paginate requires_workflow_start, :per_page => 12, :page => page
    elsif show_choice == '5'
      paginate clarity_transfer_not_complete, :per_page => 12, :page => page
    elsif show_choice == '6'
      paginate transfer_complete, :per_page  => 12, :page => page
    else
      if use_date && use_date != ''
        use_date_time = Date.parse(use_date) + 12.hours
      end
      
      if show_choice == '1'
        do_available = true
        available = true
      elsif show_choice == '2'
        do_available = true
        available = false
      else
        do_available = false
      end
      logger.debug do_available
      logger.debug "||||||"
      if search && filename_id && filename_id != '-1' && use_date_time && !do_available 
        logger.debug 'search + filename + use_date'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['(title LIKE ? OR house_number LIKE ?) AND trailer_file_id = ? AND first_use <= ? AND last_use >= ?' , "%#{search}%", "%#{search}%", filename_id, use_date_time, use_date_time]
      elsif search && filename_id && filename_id != '-1' && use_date_time && do_available && available
        logger.debug 'search + filename + use_date + show_choice = available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['(title LIKE ? OR house_number LIKE ?) AND trailer_file_id = ? AND first_use <= ? AND last_use >= ? AND enable = 1' , "%#{search}%", "%#{search}%", filename_id, use_date_time, use_date_time]
      elsif search && filename_id && filename_id != '-1' && use_date_time && do_available && !available
        logger.debug 'search + filename + use_date + show_choice = not available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['(title LIKE ? OR house_number LIKE ?) AND trailer_file_id = ? AND first_use <= ? AND last_use >= ? AND (enable = 0 OR enable IS NULL)' , "%#{search}%", "%#{search}%", filename_id, use_date_time, use_date_time]
      elsif search && filename_id && filename_id != '-1' && !do_available
        logger.debug 'search + filename'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['(title LIKE ? OR house_number LIKE ?) AND trailer_file_id = ?', "%#{search}%", "%#{search}%", filename_id]
      elsif search && filename_id && filename_id != '-1' && do_available && available
        logger.debug 'search + filename + show_choice = available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['(title LIKE ? OR house_number LIKE ?) AND trailer_file_id = ? AND enable = 1', "%#{search}%", "%#{search}%", filename_id]
      elsif search && filename_id && filename_id != '-1' && do_available && !available
        logger.debug 'search + filename + show_choice = not available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['(title LIKE ? OR house_number LIKE ?) AND trailer_file_id = ? AND (enable = 0 OR enable IS NULL)', "%#{search}%", "%#{search}%", filename_id]
      elsif search && !use_date_time && !do_available
        logger.debug 'search'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['title LIKE ? OR house_number LIKE ?', "%#{search}%", "%#{search}%"]
      elsif search && !use_date_time && do_available && available
        logger.debug 'search + show_choice = available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['(title LIKE ? OR house_number LIKE ?) AND enable = 1', "%#{search}%", "%#{search}%"]
      elsif search && !use_date_time && do_available && !available
        logger.debug 'search + show_choice = not available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['(title LIKE ? OR house_number LIKE ?) AND (enable = 0 OR enable IS NULL)', "%#{search}%", "%#{search}%"]
      elsif search && use_date_time && !do_available
        logger.debug 'search + use_date'
        paginate  :per_page => 12, :page =>page,
        :conditions => ['(title LIKE ? OR house_number LIKE ?) AND first_use <= ? AND last_use >= ?' , "%#{search}%", "%#{search}%", use_date_time, use_date_time]
      elsif search && use_date_time && do_available && available
        logger.debug 'search + use_date + show_choice = available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['(title LIKE ? OR house_number LIKE ?) AND first_use <= ? AND last_use >= ? AND enable = 1' , "%#{search}%", "%#{search}%", use_date_time, use_date_time]
      elsif search && use_date_time && do_available && !available
        logger.debug 'search + use_date + show_choice = not available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['(title LIKE ? OR house_number LIKE ?) AND first_use <= ? AND last_use >= ? AND (enable = 0 OR enable IS NULL)' , "%#{search}%", "%#{search}%", use_date_time, use_date_time]
      elsif filename_id && filename_id != '-1' && use_date_time && !do_available
        logger.debug 'filename + use_date'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['trailer_file_id = ? AND first_use <= ? AND last_use >= ?' , filename_id, use_date_time, use_date_time]
      elsif filename_id && filename_id != '-1' && use_date_time && do_available && available
        logger.debug 'filename + use_date + show_choice = available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['trailer_file_id = ? AND first_use <= ? AND last_use >= ? AND enable = 1' , filename_id, use_date_time, use_date_time]
      elsif filename_id && filename_id != '-1' && use_date_time && do_available && !available
        logger.debug 'filename + use_date + show_choice = not available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['trailer_file_id = ? AND first_use <= ? AND last_use >= ? AND (enable = 0 OR enable IS NULL)' , filename_id, use_date_time, use_date_time]
      elsif filename_id && filename_id != '-1' && !do_available
        logger.debug 'filename'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['trailer_file_id = ?', filename_id]
      elsif filename_id && filename_id != '-1' && do_available && available
        logger.debug 'filename + show_choice = available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['trailer_file_id = ? AND enable = 1', filename_id]
      elsif filename_id && filename_id != '-1' && do_available && !available
        logger.debug 'filename + show_choice = not available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['trailer_file_id = ? AND (enable = 0 OR enable IS NULL)', filename_id]
      elsif use_date_time && !do_available
        logger.debug 'use_date'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['first_use <= ? AND last_use >= ?' , use_date_time, use_date_time]
      elsif use_date_time && do_available && available
        logger.debug 'use_date + show_choice = available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['first_use <= ? AND last_use >= ? AND enable = 1' , use_date_time, use_date_time]
      elsif use_date_time && do_available && !available
        logger.debug 'use_date + show_choice = not available'
        paginate  :per_page => 12, :page =>page,
                  :conditions => ['first_use <= ? AND last_use >= ? AND (enable = 0 OR enable IS NULL)' , use_date_time, use_date_time]
      else
        logger.debug 'all'
        paginate  :all, :per_page => 12, :page =>page
      end
    end
  end 

  def enable_text
    if enable
      'Enabled'
    else
      'Not Enabled'
    end
  end

  def available
    if enable && media_file 
      'Available'
    elsif enable
      'No Media'
    else
      ''
    end
  end

  def diva_status
    if diva_data && diva_data.diva_status
      diva_data.diva_status.message
    else
      'No Diva Data'
    end
  end

  def clarity_status
    if diva_data
      diva_data.status || 'No Clarity Data'
    else
      'No Clarity Data'
    end
  end

  def add_line(line, file_id)
    element = line.split("\t")
    tabs = TrailerTabSetting.all

    house_number_position = TrailerTabSetting.find_by_field_name('house_number').position - 1
    change_date_position  = TrailerTabSetting.find_by_field_name('change_date').position - 1
    change_time_position  = TrailerTabSetting.find_by_field_name('change_time').position - 1

    logger.debug 'house_number_position'
    logger.debug house_number_position
    if house_number_position && change_date_position & change_time_position
      house_number = element[house_number_position].strip
      change_date = element[change_date_position].strip
      change_time = element[change_time_position].strip
      change = change_date_time(change_date, change_time)

      logger.debug house_number
      logger.debug change
      if house_number
        already_present = 0
        updated = 0
        added = 0
        
        trailer = Trailer.find_by_house_number(house_number)
        if trailer 
          if trailer.change >= change
            already_present = 1
          else
            updated = 1
          end
        else
          trailer = Trailer.new
          added = 1
        end

        if already_present == 0
          title_position = TrailerTabSetting.find_by_field_name('title').position - 1
          channels_position  = TrailerTabSetting.find_by_field_name('channels_text').position - 1
          ingest_status_position  = TrailerTabSetting.find_by_field_name('ingest_status').position - 1
          duration_position  = TrailerTabSetting.find_by_field_name('duration').position - 1

          trailer.house_number = house_number
          trailer.title = element[title_position].strip if title_position > -1
          trailer.change = change
          trailer.channels_text = element[channels_position].strip if channels_position > -1
          trailer.ingest_status = element[ingest_status_position].strip if ingest_status_position > -1
          trailer.duration = duration_as_seconds(element[duration_position].strip) if duration_position > -1
          trailer.trailer_file_id = file_id
        end
        logger.debug "====>"
        logger.debug file_id
        if trailer.save
          trailer.add_any_channels_needed
          { :already_present => already_present, :updated => updated, :added => added, :success => true }
        else
          { :success => false}
        end
      else
        { :success => false}
      end
    else
      { :success => false}
    end
  end

  def add_any_channels_needed
    channels = Channel.language_scope
    channels.each do |c|
      logger.debug c.id
      if !self.channel_trailers.find_by_channel_id(c.id)
        t = self.channel_trailers.new
        t.channel_id = c.id
        t.save
      end
    end 
  end

  def self.check_header(line)
    # Checks the header line has all the expect tabs in the correct order
    element = line.split("\t")
    tabs = TrailerTabSetting.all
    good = true
    message = ''
    logger.debug "=======+>"
    tabs.each do |t|
      item = element[t.position-1]#.strip
      logger.debug item
      logger.debug t.name
      if item
        if !(item == t.name)
          good = false
          message = t.name + ' is either not present or in the wrong position. '
        end
      else
        good = false
        message += t.name + ' is not present. '
      end
      logger.debug good
    end
    if !good
      message = 'Upload failed: Wrong fields. ' + message
    end
    {:status => good, :message => message}
  end

  def auto_enable
    self.enable = true
    self.first_use = self.class.next_monday(1)
    self.last_use = self.class.next_monday(3)    
    language_id = language_for_house_number(self.house_number)
    if !language_id
      errors.add_to_base("No language inferred from House Number, no channels added. ")
    end
    set_channel_enables(self, language_id)

    if !self.media_file
      link_or_create_media self
    end
  end

  def link_or_create_media(trailer)
    media_filename = create_filename(trailer.house_number, ".ppv")
    media_file = MediaFile.find_by_filename(media_filename)
      
    if !media_file
      media_file = MediaFile.new
    end
    media_file.name = trailer.house_number
    media_file.filename = media_filename
    media_file.audio_filename = media_filename.sub('.ppv',' (A1&2).ppa')
    media_file.has_audio = true
    media_file.first_use = trailer.first_use
    media_file.last_use = trailer.last_use
    media_file.status = Status.find_by_value(0)

    year_no = Useful.year_number(media_file.first_use)
    if year_no.to_i >= 2012
      media_f = MediaFolder.find_by_name('Trailer ECP ' + year_no )
      if media_f
        if MediaFile.overflow(media_f, true)
          media_f = MediaFile.overflow_folder('Trailer ECP Overflow', true)
          if !media_f
            media_f=MediaFolder.find_by_name('Trailer ECP')
          end
        end
        media_file.media_folder = media_f
      else
        media_file.media_folder = MediaFolder.find_by_name('Trailer ECP')
      end
    else
      media_file.media_folder = MediaFolder.find_by_name('Trailer ECP')
    end
    media_file.media_type = MediaType.find_by_name('Trailer ECP')
    media_file.save
    trailer.media_file = media_file
    trailer.save
  end

  def add_media
    done = false
    if self.enable && self.first_use && self.last_use 
      if !self.media_file
        if link_or_create_media self
          message = 'Media added'
          done = true
        else
          message = 'Media failed to be added.'
        end
      end
    else
      message = 'Media not added. Trailer must be enabled with first and last use dates before media can be added'
    end
    {:success => done, :message => message}
  end

  def self.next_monday(plus_weeks)
    (Date.today.monday + 5.hours + plus_weeks.week).to_s(:broadcast_calendar_format)
  end  
  
  def house_with_title
    if house_number && title
      house_number + ': ' + title
    elsif house_number
      house_number
    elsif title
      title
    else
      'No house number or title'
    end
  end

  def self.read_diva_data(trailer_read_only, diva_log)
    trailer = Trailer.find(trailer_read_only.id)
    log = DivaLog.find(diva_log.id)
    if log.nil?
      log = DivaLog.new
      log.action = 'Media Search'
      log.net_message = 'Log not created'
    end
    if trailer
      begin
        log.trailer_id = trailer.id
        filename = Rails.root.join('public','data', 'diva', 'search',  trailer.house_number + '.xml')
        log.filename = Muvi2Generic.short_pathname(filename)
        xml_string = ''
        if File.file?(filename)
          file = File.open(filename, "r")
          file.each_line do |line|
            xml_string += line
          end
          log.xml_received = xml_string
          hash_data = Hash.from_xml(xml_string)
          logger.debug "#{hash_data.inspect}"
          x = DivaSetting.xml
          logger.debug '===-====-=='
          logger.debug "#{x.inspect}"
          if hash_data[x[:media_search]].nil?
            if trailer.diva_data.nil?
              diva_data = DivaData.new
            else
              diva_data = trailer.diva_data
            end
            diva_data.xml_string = xml_string
            diva_data.diva_status_id = DivaStatus.find_by_message('Not Available').id
            if diva_data.save
              trailer.diva_data = diva_data
              if trailer.save
                log.data_message = 'Diva Data not available for this House Number'
                flash_notice = 'Diva Data not available for this House Number'
              else
                log.data_message = 'Diva Data not available for this House Number + issue saving trailer data'
                flash_notice = 'Issue saving trailer data'
              end
            else
              log.data_message = 'Diva Data not available for this House Number + issue saving diva data'
              flash_notice = 'Issue saving Diva Data'
            end
          else
            diva_house_number = hash_data[x[:media_search]][x[:media]][x[:house]]
            logger.debug "Here ===>"
            if check_house_number(diva_house_number, trailer.house_number)
              diva_data = DivaData.find_by_diva_house_number(diva_house_number)
              message = ' updated'
              if !diva_data
                diva_data = DivaData.new
                message = ' created'
              end
              diva_data.xml_string = xml_string
              diva_data.system_id = hash_data[x[:media_search]][x[:media]][x[:id]]
              diva_data.diva_house_number = diva_house_number
              diva_data.tv_standard = hash_data[x[:media_search]][x[:media]][x[:tv]]
              diva_duration = Useful.tc_string_to_rounded_seconds(hash_data[x[:media_search]][x[:media]][x[:dur]]) - DivaSetting.duration_offset
              diva_data.diva_duration = diva_duration
              if check_duration(trailer.duration, diva_duration)
                diva_data.diva_status_id = DivaStatus.find_by_message('Available and Ready for Transfer').id
              else
                diva_data.diva_status_id = DivaStatus.find_by_message('Duration Discrepancy').id
              end
              if diva_data.save
                trailer.diva_data = diva_data
                if trailer.save
                  log.data_message = 'Diva Data ' + message
                  flash_notice = 'Diva Data ' + message
                else
                  log.data_message = 'Diva Data not created at the trailer save stage'
                  flash_notice = 'Diva Data not created at the trailer save stage'
                end
              else
                log.data_message = 'Diva Data not created at the diva data save stage'
                flash_notice = 'Diva Data not created at the diva data save stage'
              end
            else
              diva_data = trailer.diva_data
              if diva_data.nil?
                diva_data = DivaData.new
              end
              diva_data.xml_string = xml_string
              diva_data.diva_house_number = diva_house_number
              diva_data.diva_status_id = DivaStatus.find_by_message('House Number Mismatch').id
              if diva_data.save
                if trailer.save
                  log.data_message = 'Diva Data issue with wrong house number'
                  flash_notice = 'Diva Data issue with wrong house number'
                else
                  log.data_message = 'Diva Data not created at the trailer save stage (House Number mismatch)'
                  flash_notice = 'Diva Data not created at the trailer save stage (House Number mismatch)'
                end
              else
                log.data_message = 'Diva Data not created at the diva data save stage(House Number mismatch)'
                flash_notice = 'Diva Data not created at the diva data save stage(House Number mismatch)'
              end
            end
          end
        else
          if trailer.diva_data.nil?
            diva_data = DivaData.new
          else
            diva_data = trailer.diva_data
          end
          diva_data.diva_status_id = DivaStatus.find_by_message('Awaiting Response').id
          if diva_data.save
            trailer.diva_data = diva_data
            if trailer.save
              log.data_message = 'Filename not found'
              flash_notice = 'Diva Data not created as the xml was not returned from Diva. The Diva server may not be responding'
            else
              log.data_message = 'Filename not found + Issue saving trailer data'
              flash_notice = 'Issue saving trailer data. The Diva server may not be responding'
            end
          else
            log.data_message = 'Filename not found + Issue saving diva data'
            flash_notice = 'Issue saving Diva Data. The Diva server may not be responding'
          end
        end
        {:processed => true, :flash_notice => flash_notice}
      #rescue NoMethodError
      #  {:processed => true, :flash_notice => "Invalid filename"}
      #rescue Exception => exc
      #  {:processed => false, :flash_notice => "Unexpected error. It is possible the Diva web server did not respond"}
      end
    end
    log.diva_status_id = diva_data.diva_status_id
    log.save
    {:processed => true, :flash_notice => flash_notice}
  end

  def self.read_diva_workflow_data(trailer_read_only, workflow, diva_log)
    trailer = Trailer.find(trailer_read_only.id)
    if diva_log
      log = DivaLog.find(diva_log.id)
    end
    if log.nil?
      log = DivaLog.new
      if workflow
        log.action = 'Workflow Start'
      else
        log.action = 'Workflow Update'
      end
      log.net_message = 'Log not created'
    end
    if trailer
      begin
        log.trailer_id = trailer.id
        if trailer.diva_data 
          if workflow
            xml_base = trailer.diva_data.system_id
            if xml_base
              filename = Rails.root.join('public','data', 'diva', 'workflow',  xml_base + '.xml')
            end
          else
            xml_base = trailer.diva_data.job_id.to_s
            if xml_base
              filename = Rails.root.join('public','data', 'diva', 'workflow_status',  xml_base + '.xml')
            end
          end
          if filename
            log.filename = Muvi2Generic.short_pathname(filename)
            xml_string = ''
            if File.file?(filename)
              file = File.open(filename, "r")
              file.each_line do |line|
                xml_string += line
              end
              log.xml_received = xml_string
              hash_data = Hash.from_xml(xml_string)
              logger.debug "#{hash_data.inspect}"
              x = DivaSetting.job_xml
              logger.debug '===-====-=='
              logger.debug "#{x.inspect}"
              if hash_data[x[:job]].nil?
                if trailer.diva_data.nil?
                  diva_data = DivaData.new
                else
                  diva_data = trailer.diva_data
                end
                diva_data.job_xml_string = xml_string
                diva_data.status = 'Not Available'
                diva_data.diva_status = DivaStatus.diva_workflow_message_to_status(diva_data.status).id
                if diva_data.save
                  trailer.diva_data = diva_data
                  if trailer.save
                    log.data_message = 'Diva Data not available for this Diva ID'
                    flash_notice = 'Diva Job Data not available for this Diva ID'
                  else
                    log.data_message = 'Diva Data not available for this Diva ID + Issue saving trailer data'
                    flash_notice = 'Issue saving trailer data'
                  end
                else
                  log.data_message = 'Diva Data not available for this Diva ID + Issue saving diva data'
                  flash_notice = 'Issue saving Diva Data'
                end
              else
                diva_job_id = hash_data[x[:job]][x[:job_id]]
                diva_data = trailer.diva_data
                message = ' updated'
                if !diva_data
                  diva_data = DivaData.new
                  message = ' created'
                end
                diva_data.job_xml_string = xml_string
                diva_data.job_id = diva_job_id
                diva_data.status = hash_data[x[:job]][x[:status]]
                diva_data.diva_status_id = DivaStatus.diva_workflow_message_to_status(diva_data.status).id
                diva_data.job_created = hash_data[x[:job]][x[:job_created]]
                diva_data.job_started = hash_data[x[:job]][x[:job_started]]
                if diva_data.status == 'Completed'
                  diva_data.job_completed = hash_data[x[:job]][x[:job_completed]]
                else
                  diva_data.job_completed = nil
                end
                if diva_data.save
                  trailer.diva_data = diva_data
                  if trailer.save
                    self.set_status_to_queued_if_complete(trailer)
                    log.data_message = 'Diva Job Data ' + message
                    flash_notice = 'Diva Job Data ' + message
                  else
                    log.data_message = 'Diva Job Data not created at the trailer save stage'
                    flash_notice = 'Diva Job Data not created at the trailer save stage'
                  end
                else
                  log.data_message = 'Diva Job Data not created at the diva data save stage'
                  flash_notice = 'Diva Job Data not created at the diva data save stage'
                end
              end
            else
              flash_notice = 'Diva Job Data not created as the xml was not returned from Diva Job request'
              log.data_message = flash_notice
              log.diva_status_id = DivaStatus.find_by_message('Not Available')
            end
          else
            flash_notice = 'Diva Job Data not created as the xml was not returned from Diva Job request (no valid filename)'
            log.data_message = flash_notice
            log.diva_status_id = DivaStatus.find_by_message('Not Available')
          end
        else
          flash_notice = 'Diva Job Data not created as there is no Diva Media Search data.'
          log.data_message = flash_notice
          log.diva_status_id = DivaStatus.find_by_message('Not Available')
        end
        {:processed => true, :flash_notice => flash_notice}
      #rescue NoMethodError
      #  {:processed => true, :flash_notice => "Invalid filename"}
      #rescue Exception => exc
      #  {:processed => false, :flash_notice => "Unexpected error. It is possible the Diva web server did not respond"}
      end
    end
    if diva_data && diva_data.diva_status_id
      log.diva_status_id = diva_data.diva_status_id
    end
    log.save
    {:processed => true, :flash_notice => flash_notice}
  end

  def self.filter_with_media_id(last_use, channel_name)
    
    if last_use.nil?
      trailers = find(:all, :conditions => ['NOT(media_file_id is ?)',nil])
    else
      last_use_date = Date.parse(last_use).strftime('%F')
      trailers = find(:all, :conditions => ['NOT(media_file_id is ?) AND DATE(last_use) >= ? ',nil, last_use_date])
    end

    if channel_name
      channel = Channel.find_by_name(channel_name)
      if channel
        result = []
        trailers.each do |trailer|
          channel_trailers = trailer.channel_trailers
          channel_trailers.each do |ct|
            if ct.enable
              if ct.channel == channel
                result << trailer
              end
            end
          end
        end
        result
      else
        trailers
      end
    else
      trailers
    end
  end

  def self.filter_expired_updated_after(params)
    if params[:last_use] && params[:updated_after]
      last_use_date = Date.parse(params[:last_use]).strftime('%F')
      updated_after_date = Date.parse(params[:updated_after]).strftime('%F')
#      find(:all, :conditions => ['DATE(last_use) >= ? AND DATE(updated_at) >= ?', last_use_date, updated_after_date])
      find(:all, :select=> "DISTINCT(promos.id), promos.*", :joins => :media_files, :conditions => ['DATE(promos.last_use) >= ? AND (DATE(promos.updated_at) >= ? OR DATE(media_files.updated_at) >= ?)', last_use_date, updated_after_date, updated_after_date])
    elsif params[:last_use]
      last_use_date = Date.parse(params[:last_use]).strftime('%F')
      find(:all, :conditions => ['DATE(last_use) >= ? ' , last_use_date])
    elsif params[:updated_after]
      updated_after_date = Date.parse(params[:updated_after]).strftime('%F')
#      find(:all, :conditions => ['DATE(updated_at) >= ?', updated_after_date])
      find(:all, :select=> "DISTINCT(promos.id), promos.*", :joins => :media_files, :conditions => ['DATE(promos.updated_at) >= ? OR DATE(media_files.updated_at) >= ?', updated_after_date, updated_after_date])      
    else
      :all
    end
  end

  def self.requires_diva_data
    nil_diva = Trailer.find(:all, :conditions => ['enable = ? AND NOT(media_file_id is ?) AND diva_data_id is ?', true, nil, nil])
    not_available = Trailer.all :joins => [:media_file, {:diva_data => :diva_status}], :conditions => {'diva_statuses.value' => -2..0, :enable => true }
    (nil_diva + not_available).sort_by(&:title)
  end

  def self.requires_workflow_start
    Trailer.all :joins => {:diva_data => :diva_status}, :conditions => {:diva_datas => {:status => nil, :diva_statuses => {:value => 1}}}
  end

  def self.clarity_transfer_not_complete
    #Trailer.all :joins => {:diva_data => :diva_status}, :conditions => ['status <> ? AND diva_statuses.value = ?', 'Completed', 2]
    Trailer.all :joins => {:diva_data => :diva_status}, :conditions => {:diva_datas => {:diva_statuses => {:value => 2..3}}}
  end

  def self.transfer_complete
    Trailer.all :joins => {:diva_data => :diva_status}, :conditions => ['diva_statuses.value = ?', 4]
  end
  
  def self.orphaned_diva_data
    trailers = Trailer.all
    orphaned = []
    trailers.each do |trailer|
      if trailer.diva_data_id
        if trailer.diva_data.nil?
          orphaned << trailer
        end
      end
    end
    orphaned
  end

  def self.delete_orphaned_diva_data_references
    trailers = self.orphaned_diva_data
    puts trailers.count
    trailers.each do |trailer|
      trailer.diva_data_id = nil
      trailer.save
    end
  end

protected
  def check_enabled
    ok  = true
    if self.enable
      if !self.first_use
        ok = false
        errors.add(:first_use, "must be present if trailer enabled")
      end
      if !self.last_use
        ok = false
        errors.add(:last_use, "must be present if trailer enabled")
      end
      if !at_least_one_channel_enabled(self.channel_trailers)
        ok = false
        errors.add_to_base("At least one channel must be enabled, if trailer enabled")
      end
      valid_durations = DivaSetting.valid_durations
      valid = false
      valid_durations.each do |dur|
        if self.duration == dur
          valid = true
        end
      end
      if !valid
        ok = false
        errors.add(:duration, " must be one of the valid durations (" + valid_durations.join(", ") + ")")
      end
    else
      logger.debug "Not enabled"
    end
    ok
  end

  

private
  def change_date_time (change_date, change_time)
    # Expects change_date to be a string in the format dd/mm/yyyy
    # Expects change_time to be a string in the format hh:mm
    
    if change_date && change_time
      DateTime.strptime(change_date + change_time,"%d/%m/%Y%H:%M") 
    else
      nil
    end
    
  rescue ArgumentError
    nil
  end

  def duration_as_seconds(duration_string)
    if duration_string
      Time.parse(duration_string).seconds_since_midnight.to_i
    else
      nil
    end
  end

  def at_least_one_channel_enabled(channel_trailers)
    valid = false
    if channel_trailers
      channel_trailers.each do |c|
        if c.enable
          valid = true
        end
      end
    end
    valid
  end

  def language_for_house_number(house)
    
    language_id = nil
    if house && house != ''
      prefixes = TrailerHouseNumberPrefix.all
      prefixes.each do |p|
        if p.prefix && p.prefix != ''
          if house.starts_with?(p.prefix)
            language_id = p.language_id
            break
          end
        end
      end
    end
    language_id
  end

  def set_channel_enables(trailer, language_id)
    if language_id
      trailer.channel_trailers.each do |c|
        if c.channel.language.id == language_id
          c.enable = true
        else
          c.enable = false
        end
        c.save
      end
    end
  end

  def create_filename(name, extension)
    Useful.strip_filename(name).upcase + extension
  end

  def self.check_house_number(house, diva_house)
    if house.nil?
      false
    elsif diva_house.nil?
      false
    else
      house.casecmp(diva_house).zero?
    end
  end

  def self.check_duration(dur, diva_duration)
    if dur.nil?
      false
    elsif diva_duration.nil?
      false
    else
      dur == diva_duration
    end
  end

  def self.set_status_to_queued_if_complete(trailer)
    if trailer.diva_status == 'Transfer Complete'
      if trailer.media_file.status.message == 'Not loaded'
        trailer.media_file.status_id = Status.find_by_message('Queued').id
        trailer.media_file.save
      end
    end
  end

end
