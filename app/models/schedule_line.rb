class ScheduleLine < ActiveRecord::Base
  
  belongs_to :schedule_file
  validates_presence_of :schedule_file_id
  
  default_scope :order => :start
  
  def self.search(params)
    if params[:schedule_filename].nil? || params[:schedule_filename] == '-1'
      result = all
    else
      result = find_all_by_schedule_file_id(params[:schedule_filename])
    end
    result.paginate   :per_page => 18, :page =>params[:page]
  end
  
  def self.channel_name(params)
    if params[:schedule_filename].nil?||params[:schedule_filename] == '-1'
      chan = "all channels"
    else
      line = find_by_schedule_file_id(params[:schedule_filename])
      if line.schedule_file.channel
        chan = line.schedule_file.channel.name
      else
        chan = "all channels"
      end
    end
    chan
  end
  
  def self.get_start_stop_dates(file)
    tab = ScheduleTabSetting.delete_tab_info
    found = false
    eof = false
    
    while (!found) && (!eof)
      line=file.gets
      if line      
        element = line.split("\t")
        logger.debug tab[:deletion_rules]-1
        logger.debug element[tab[:deletion_rules]-1]
        found = element[tab[:deletion_rules]-1] == 'DeletionRules'
#        logger.debug line
      else
        eof = true
      end
    end
    
    if found
      start = start_time(element, tab)
      stop = stop_time(element, tab)
      dates = {:found => true, :start => start, :stop => stop}
    else
      dates = {:found => false}
    end
  end
  
  def self.get_channel(file)
    tab = ScheduleTabSetting.tab_info
    found = false
    while (line=file.gets) && (!found)
      element = line.split("\t")
      programme = element[tab[:programme]-1]
      if programme
        programme.strip!
        if programme == "P"
          channel_code = element[tab[:channel]-1].strip
          channel = Channel.find_by_bss_name(channel_code)
          found=true
        end
      end
    end
    channel
  end
  
  def self.delete_date_range(dates, channel)
    if dates[:found]
      start = dates[:start]
      stop = dates[:stop]
      if channel
        lines = all(:conditions => ['schedule_lines.start >= ? and schedule_lines.start <= ? and channels.name = ?',start, stop, channel.name], 
                  :joins => {:schedule_file, :channel})
        lines.each do |l|
          l.destroy
        end
      end
    end
  end
  
  def self.delete_using_file_details(file)
    tab = ScheduleTabSetting.delete_tab_info
    found = false
    eof = false
    
    while (!found) && (!eof)
      line=file.gets
      if line      
        element = line.split("\t")
        logger.debug tab[:deletion_rules]-1
        logger.debug element[tab[:deletion_rules]-1]
        found = element[tab[:deletion_rules]-1] == 'DeletionRules'
#        logger.debug line
      else
        eof = true
      end
    end
    
    if found
      start = start_time(element, tab)
      stop = stop_time(element, tab)
      logger.debug start
      logger.debug stop
      destroy_all(['start >= ? AND start <= ?', start, stop])
    end
  end
  
  def self.process_file(file, file_in_db)
    tab = ScheduleTabSetting.tab_info
    while line=file.gets
      element = line.split("\t")
      logger.debug tab[:programme]
      programme = element[tab[:programme]-1]
      if programme
        programme.strip!
        if programme == "P"
          schedule = new
          schedule.start = schedule_time(element, tab)
          schedule.house_no = element[tab[:house_number]-1].strip
          schedule.title = element[tab[:title]-1].strip
          schedule.series_title = element[tab[:series_title]-1].strip
          schedule.series_number = element[tab[:series_number]-1].strip
          schedule.schedule_file = file_in_db
          schedule.save
        end
      end
    end
  end
     
  def self.start_time(element, tab)
    time = element[tab[:start_time]-1].to_s.strip
    date = element[tab[:start_date]-1]
    convert_time(date, time, 2)
  end
  
  def self.stop_time(element, tab)
    time = element[tab[:stop_time]-1].to_s.strip
    date = element[tab[:stop_date]-1]
    convert_time(date, time, 2)
  end
  
  def self.schedule_time(element, tab)
    time = element[tab[:time]-1].to_s.strip
    date = element[tab[:date]-1]
    convert_time(date, time, 4)
  end
  

  def self.convert_time(date, time, digits)
    logger.debug '==========>Date ' + date
    logger.debug '==========>Time ' + time
    hour = time[0,2].to_i
    minute = time[3,2].to_i 
    logger.debug '==========>Hour ' + hour.to_s
    logger.debug '==========>Minute ' + minute.to_s
    
    if digits == 2
      DateTime.strptime(date, '%d/%m/%y') + hour.hours + minute.minutes
    else
      DateTime.strptime(date, '%d/%m/%Y') + hour.hours + minute.minutes
    end
  end  
        
end
