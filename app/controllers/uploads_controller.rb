class UploadsController < ApplicationController
  
require 'net/http'  
require 'rexml/document'
include REXML

  def index
    remove_v4 = true
    @channels = Channel.display(remove_v4)
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def check_password
    if params[:password] == "clarity"
      redirect_to uploads_path
    else
      flash[:notice] = 'Incorrect password'
      redirect_to previews_path
    end
  end
  
  def upload_playlist
    if params[:playlist].nil?
      flash[:notice] = 'Please select a file'
      redirect_to uploads_path
    else
      uploaded_io = params[:playlist]
      filename = Rails.root.join('public','data', 'playlist', uploaded_io.original_filename)
      
      create_folder_if_not_exist(filename)
    
      File.open(filename, 'w') do |file|
        file.write(Iconv.iconv("UTF-8",CHARSET_FORMAT,uploaded_io.read))
      end
    
      file = File.new(filename, "r")
      channel = PlaylistLine.get_channel(file, position_info)
      pl_filename = PlaylistFilename.find_or_create_by_filename(filename.to_s)
      pl_filename.channel = channel
      pl_filename.save
      logger.debug '==========>'
      logger.debug channel.name
    
      PlaylistLine.destroy_all(['playlist_filename_id = ?', pl_filename.id])
      file=File.new(filename, "r")
    
      part_no = 0
      house_no = "xxxxx"
      date_offset = 0
    
      while (line=file.gets)
        playlist = PlaylistLine.new
        playlist.playlist_filename_id = pl_filename.id
        playlist.addline(line, position_info, part_no, house_no, date_offset, pl_filename)
        part_no = playlist.part_no
        house_no = playlist.house_number
        date_offset = playlist.date_offset
      end
    
      redirect_to playlist_lines_path_with_filename(pl_filename.id)
    end
  end
  
  def upload_schedule
    if params[:schedule].nil?
      flash[:notice] = 'Please select a file'
      redirect_to uploads_path
    else
      uploaded_io = params[:schedule]
      filename = Rails.root.join('public','data', 'schedule', uploaded_io.original_filename)
      create_folder_if_not_exist(filename)
      File.open(filename, 'w') do |file|
        file.write(Iconv.iconv("UTF-8",CHARSET_FORMAT,uploaded_io.read))
      end
    
      file = File.new(filename, "r")
      dates =ScheduleLine.get_start_stop_dates(file)
      channel =ScheduleLine.get_channel(file)
      ScheduleLine.delete_date_range(dates, channel)
      file_in_db = ScheduleFile.new_with_dates(filename, dates, channel)
    
      file = File.new(filename, "r")
      ScheduleLine.process_file(file, file_in_db)
    
      redirect_to schedule_line_path_with_filename(file_in_db)
    end
  end
  
  def upload_schedule_v4
    if params[:schedule].nil?
      flash[:notice] = 'Please select a file'
      redirect_to uploads_path
    else
      uploaded_io = params[:schedule]
      filename = Rails.root.join('public','data', 'schedule', uploaded_io.original_filename)
      create_folder_if_not_exist(filename)
      File.open(filename, 'w') do |file|
        file.write(Iconv.iconv("UTF-8",CHARSET_FORMAT,uploaded_io.read))
      end
    
      file = File.new(filename, "r")
      dates =ScheduleLine.get_start_stop_dates(file)
      channel = Channel.find_by_name("V4")
      ScheduleLine.delete_date_range(dates, channel)
      file_in_db = ScheduleFile.new_with_dates(filename, dates, channel)
    
      file = File.new(filename, "r")
      ScheduleLine.process_file(file, file_in_db)
    
      redirect_to schedule_line_path_with_filename(file_in_db)
    end
  end


  def web_upload_press_file
    channel = Channel.find_by_name(params[:channel]) 
    if channel.nil?
      flash[:notice] = "Invalid channel"
      redirect_to (uploads_path)   
    else
      begin
        filename = Channel.filename(channel,Date.parse(params[:press_date]))
      rescue
        filename = nil
      end
      
      if filename.nil?
          flash[:notice] = "Please enter a date"
          redirect_to (uploads_path)
      else
        local_filename = Rails.root.join('public','data', 'press', filename)
        create_folder_if_not_exist(local_filename)
        if params[:english]
          url = channel.path + filename + '?eng=true'
        else
          url = channel.path + filename 
        end
        begin
          Net::HTTP.start(channel.domain) do |http|
            resp = http.get(url)
            File.open(local_filename, 'w') do |file|
              file.write(Iconv.iconv("UTF-8//IGNORE", channel.encoding, resp.body))
            end
          end
          process_press_file(local_filename,channel)
          redirect_to(press_lines_with_date(params[:press_date], params[:channel]))
        rescue Exception => exc
          logger.error "Error processing Press File #{exc.inspect}" 
          flash[:notice] = "Unexpected error. " + exc.message
          redirect_to(uploads_path)
        end
      end
    end
  end
  ## Here
  def web_upload_clipsource
    debug_start_time = Time.current
    channel = Channel.find_by_name(params[:channel]) 
    if channel.nil?
      flash[:notice] = "Invalid channel"
      redirect_to (uploads_path)   
    else
      begin
        filenames = Channel.clipsource_filename(channel, Date.parse(params[:press_date]), false)
        xml_filenames = Channel.clipsource_filename(channel, Date.parse(params[:press_date]), true)
        legacy_filename = Channel.filename(channel, Date.parse(params[:press_date]))
        legacy_local_filename = Rails.root.join('public','data', 'press', legacy_filename)
      rescue
        filenames = nil
        legacy_filename = nil
      end
      
      if filenames.nil?
          flash[:notice] = "Please enter a date"
          redirect_to (uploads_path)
      else
      	temp = true
        url_suffixes = Channel.clipsource_url_suffix(channel, Date.parse(params[:press_date]), false)
        
        download_time = 0
        filenames.each_with_index do |filename, index|
          local_filename = Rails.root.join('public','data', 'clipsource', filename)
          legacy_xml_filename = Rails.root.join('public','data', 'clipsource', 'xml', xml_filenames[index])
          create_folder_if_not_exist(local_filename)
          url = channel.clipsource_path + url_suffixes[index]
          logger.debug "======>" + url
        
          start_download = Time.current
          uri =URI.parse("https://" + channel.clipsource_domain + url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          begin
            resp = http.get(uri.request_uri)
          rescue Exception => exc
            logger.error "Error downloaded Press File #{exc.inspect}"
            flash[:notice] = "Unexpected error. It is possible the site is not responding"
            redirect_to(uploads_path)
            return
          end
          File.open(local_filename, 'w') do |file|
            file.write(Iconv.iconv("UTF-8//IGNORE", channel.encoding, resp.body))
          end
          this_download = Time.current - start_download
          download_time = download_time + this_download
          logger.debug "J<===>"
          logger.debug this_download.to_s
          logger.debug resp.content_type
          
#          Net::HTTP.start(channel.clipsource_domain) do |http|
#            resp = http.get(url)
#            File.open(local_filename, 'w') do |file|
#              file.write(Iconv.iconv("UTF-8//IGNORE", channel.encoding, resp.body))
#            end
#          end
          temp = process_clipsource_file(local_filename, channel, legacy_local_filename, legacy_xml_filename)
					break if temp.nil?
        end
        
 
        begin
          if temp
            time_taken = Time.current - debug_start_time
						flash[:notice] = 'Done in (seconds): ' + '%.1f' % time_taken + '. Download time: ' + '%.1f' % download_time 
						redirect_to(press_lines_with_date(params[:press_date], params[:channel]))
					else
						flash[:notice] = "Unexpected error. It is possible the file is the wrong format or empty"
						redirect_to(uploads_path)
          end
        rescue Exception => exc
          logger.error "Error processing Press File #{exc.inspect}"
          flash[:notice] = "Unexpected error. It is possible the file is the wrong format"
          redirect_to(uploads_path)
        end
      end
    end
  end
  
  def web_upload_xml_clipsource
    debug_start_time = Time.current
    channel = Channel.find_by_name(params[:channel]) 
    error_message = ''
    success = true
    if channel.nil?
      flash[:notice] = "Invalid channel"
      redirect_to (uploads_path)   
    else
      begin
        press_date = Date.parse(params[:press_date])
        filenames = Channel.clipsource_filename(channel, press_date, true)
        legacy_filenames = Channel.clipsource_filename(channel, press_date, false)
      rescue
        filenames = nil
        legacy_filename = nil
      end
      
      if filenames.nil?
          flash[:notice] = "Please enter a date"
          redirect_to (uploads_path)
      else
      	url_suffixes = Channel.clipsource_url_suffix(channel, press_date, true)
        
        download_time = 0
        process_time = 0
        filenames.each_with_index do |filename, index|
          local_filename = Rails.root.join('public','data', 'clipsource', 'xml', filename)
          legacy_local_filename = Rails.root.join('public','data', 'clipsource', legacy_filenames[index])
          logger.debug "===> Legacy local ===>" + legacy_local_filename
          create_folder_if_not_exist(local_filename)
          url = channel.clipsource_path + url_suffixes[index]
          logger.debug("https://" + channel.clipsource_domain + url)
          start_download = Time.current
          uri =URI.parse("https://" + channel.clipsource_domain + url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          begin
            resp = http.get(uri.request_uri)
          rescue Exception => exc
            logger.error "Error downloaded Press File #{exc.inspect}"
            flash[:notice] = "Unexpected error. It is possible the site is not responding"
            redirect_to(uploads_path)
            return
          end
          if resp.code != "200"
            flash[:notice] = "Unexpected error getting file. " + resp.code + ": " + resp.message + ". Please contact MuVi2."
            redirect_to(uploads_path)
            return
          end

          File.open(local_filename, 'w') do |file|
            file.write(Iconv.iconv("UTF-8//IGNORE", channel.encoding, resp.body))
          end
          this_download = Time.current - start_download
          download_time = download_time + this_download
          
          start_process = Time.current
          temp = process_clipsource_xml_file(local_filename, channel, legacy_local_filename)
          logger.debug temp.inspect
          if !temp[:success]
            new_message = 'Issue with date: ' + (press_date + index.day).strftime("%Y-%m-%d")  + ": " + temp[:message] + ". "
            error_message = error_message + new_message
            success = false
          end
          this_process = Time.current - start_process
          process_time = process_time + this_process
        end
        
        begin
          if success
            time_taken = Time.current - debug_start_time
            #flash[:notice] = 'Done in (seconds): ' + '%.1f' % time_taken + '. Download time: ' + '%.1f' % download_time + '. Process time: ' + '%.1f' % process_time
            flash[:notice] = 'Done: ' + '%.1f' % time_taken
            redirect_to(press_lines_with_date(params[:press_date], params[:channel]))
          else
            flash[:notice] = "Unexpected error. " + error_message
            redirect_to(uploads_path)
          end
        rescue Exception => exc
          logger.error "Error processing Press File #{exc.inspect}"
          flash[:notice] = "Unexpected error. It is possible the file is the wrong format"
          redirect_to(uploads_path)
        end
      end
    end
  end
  
  
  def process_press_file (filename,channel)
    
    base_filename = File.basename(filename)
    press_filename = PressFilename.find_or_create_by_filename(base_filename)
    press_filename.import_date = DateTime.now
    press_filename.save
    
    Priority.store_priority press_filename.id
    
    PressLine.destroy_all(['press_filename_id = ?', press_filename.id])

    file=File.new(filename, "r")
    last_time = Time.parse("00:01") #sets to a minute past midnight today
    line=file.gets

    while (line=file.gets)
      press = PressLine.new
      press.add_line(line, tab_info, last_time, channel, press_filename)
      last_time = press.last_start_time
    end
    
  end
  
  def process_clipsource_file (filename, channel, legacy_filename, legacy_xml_filename)
    
    base_filename = File.basename(filename)
    press_filename = PressFilename.find_or_create_by_filename(base_filename)
    press_filename.import_date = DateTime.now
    press_filename.save
    
    legacy_base_filename = File.basename(legacy_filename)
    legacy_press_filename = PressFilename.find_by_filename(legacy_base_filename)
    legacy_base_xml_filename = File.basename(legacy_xml_filename)
    legacy_press_xml_filename = PressFilename.find_by_filename(legacy_base_xml_filename)
    
    Priority.store_priority press_filename.id
    
    PressLine.destroy_all(['press_filename_id = ?', press_filename.id])
    
    if legacy_press_filename
    	PressLine.destroy_all(['press_filename_id = ?', legacy_press_filename.id])
    end
    if legacy_press_xml_filename
      PressLine.destroy_all(['press_filename_id = ?', legacy_press_xml_filename.id])
    end

    file=File.new(filename, "r")
    last_time = Time.parse("00:01") #sets to a minute past midnight today
    line=file.gets

    while (line=file.gets)
      press = PressLine.new
      temp = press.add_line_clipsource(line, tab_info, last_time, channel, press_filename)
      break if temp.nil?
      last_time = press.last_start_time
      logger.debug last_time
    end
    temp #to send nil if exited early
  end

  def process_clipsource_xml_file (filename, channel, legacy_filename)
    
    base_filename = File.basename(filename)
    press_filename = PressFilename.find_or_create_by_filename(base_filename)
    press_filename.import_date = DateTime.now
    press_filename.save
    
    legacy_base_filename = File.basename(legacy_filename)
    legacy_press_filename = PressFilename.find_by_filename(legacy_base_filename)
    Priority.store_priority press_filename.id
    SpecialScheduleStore.store_ads_join press_filename.id
    
    num_deleted = PressLine.destroy_all(['press_filename_id = ? AND channel_id = ?', press_filename.id, channel.id]).count
    
    if legacy_press_filename
    	num_deleted = PressLine.destroy_all(['press_filename_id = ? AND channel_id = ?', legacy_press_filename.id, channel.id]).count
    end
    xml_string = ''
    if File.file?(filename)
      xmlDoc = Document.new(File.new(filename))
      events = XPath.match(xmlDoc, '//eventList/event')
      contents = XPath.match(xmlDoc, "//content")
      results = []
      events.each_with_index do |event, index|
        start_time_utc_text = event.elements['timeList/time/startTime'].text
        start_time = text_time_to_kludged_local(start_time_utc_text)
        content_ref_id = event.elements["contentIdRef"].text
        content_data = content_data_for_content_ref_id(contents, content_ref_id)
        if content_data[:valid]
          press = PressLine.new
          press.add_clipsource_xml(start_time, content_ref_id, channel, press_filename, content_data)
          if press.save
            SpecialScheduleStore.add_press_line_ids_to_joins(press.start, press_filename.id, press.id)
            results << {:success => true, :message => 'Good'}
          else
            results << {:success => false, :message => 'Issue saving data'}
          end
        else
          results << {:success => false, :message => 'Issue with missing data'}
        end
      end
    else
      results << {:success => false, :message => 'Issue with data download'}
    end
    final_success = true
    final_message = ''
    results.each do |result|
      final_success = final_success && result[:success]
      if !result[:success]
        final_message = final_message + result[:message] + '. '
      end
    end
    return {:success => final_success, :message => final_message}
  end
  
  def upload_press_file
    uploaded_io = params[:press_file]
    channel = Channel.find_by_name(params[:channel])
    
    if channel.nil? 
      flash[:notice] = "Invalid channel"
      redirect_to(uploads_path)
    else

      begin
        filename = Rails.root.join('public','data', 'press', uploaded_io.original_filename)
        create_folder_if_not_exist(filename)
        File.open(filename, 'w') do |file|
          file.write(Iconv.iconv("UTF-8//IGNORE", channel.encoding, uploaded_io.read))
        end

        process_press_file(filename,channel)
        redirect_to(press_lines_url)
      rescue NoMethodError
        flash[:notice] = "Invalid filename"
        redirect_to(uploads_path)
      rescue Exception => exc
        logger.error "Error processing Press File #{exc.inspect}"
        flash[:notice] = "Unexpected error. It is possible the file is the wrong format"
        redirect_to(uploads_path)
      end
      
    end
  end
  
  private
  def position_info
    event = PlaylistPositionSetting.find_by_item("Event No")
    start_date = PlaylistPositionSetting.find_by_item("Date")
    start_time = PlaylistPositionSetting.find_by_item("Time")
    duration = PlaylistPositionSetting.find_by_item("Duration")
    title = PlaylistPositionSetting.find_by_item("Title")
    source = PlaylistPositionSetting.find_by_item("Source")
    type = PlaylistPositionSetting.find_by_item("Material Type")
    material_id = PlaylistPositionSetting.find_by_item("Material ID")
    long_title = PlaylistPositionSetting.find_by_item("Long Title")
    timecode = PlaylistPositionSetting.find_by_item("Timecode")
    {:event => event, :title => title, :source => source,
              :start_date => start_date, :start_time => start_time, :duration => duration,
              :type => type, :material_id => material_id, :long_title => long_title, :timecode => timecode}
    
  end
  
  def tab_info
    start_date = PressTabSetting.find_by_item("Date")
    start_time = PressTabSetting.find_by_item("Time")
    display = PressTabSetting.find_by_item("Display Title")
    original = PressTabSetting.find_by_item("Original Title")
    lead_text = PressTabSetting.find_by_item("Lead Text")
    series_number = PressTabSetting.find_by_item("Series Number")
    year_number = PressTabSetting.find_by_item("Year Number")
    eidr = PressTabSetting.find_by_item("EIDR")
    sport = PressTabSetting.find_by_item("Content ID")
    
    {:start_date => start_date, :start_time => start_time, :display => display, :original => original, 
      :lead_text => lead_text, :series_number => series_number, :year_number => year_number, :eidr => eidr,
      :sport => sport}
  end
  
  def create_folder_if_not_exist(filename)
    
    dirname = File.dirname(filename)
    Dir.mkdir(dirname) unless File.directory?(dirname)

  end
  
  def authenticate_clipsource
  
    auth_params = {'username' => 'david@muvi2.co.uk', 'password' => 'mJ8#xTtRiL[T9E', }
    uri = URI('http://press.mtgdanmark.dk/pressweb/590c32d7656f6/login_check')
    request = Net::HTTP::Post.new('http://press.mtgdanmark.dk/pressweb/590c32d7656f6/login_check')
    request.set_form_data(auth_params)
    
    Net::HTTP.start('press.mtgdanmark.dk') do |http|
      request = Net::HTTP::Post.new('http://press.mtgdanmark.dk/pressweb/590c32d7656f6/login_check')
      request.set_form_data(auth_params)
      response = http.request(request)
      logger.debug "XXXX"
      logger.debug response
      logger.debug response.body    
    end
  end
  
  def fetch(uri_str, limit = 10)
    # You should choose a better exception.
    raise ArgumentError, 'too many HTTP redirects' if limit == 0

    response = Net::HTTP.get_response(URI(uri_str))

    case response
    when Net::HTTPSuccess then
      response
    when Net::HTTPRedirection then
      location = response['location']
      logger.debug "Limit: " + limit.to_s
      logger.debug location
      logger.debug response.body
      
      warn "redirected to #{location}"
      fetch(location, limit - 1)
    else
      response.value
    end
  end
  
  def text_time_to_kludged_local(text_time)
    # Returns a time which is actually the local time but thinks its UTC
    start_time_utc = Time.parse(text_time) 
    start_time_utc + start_time_utc.in_time_zone("Stockholm").utc_offset
  end

  def title_list_to_titles(title_list)
    series_original = ""
    series_local = ""
    content_original = ""
    content_local = ""
    title_list.each do |title|
      if title.attributes['type'] == 'series'
        if title.attributes['original'] == 'true'
          series_original = title.text
        else
          series_local = title.text
        end
      else
        if title.attributes['original'] == 'true'
          content_original = title.text
        else
          content_local = title.text
        end
      end
    end
    {:series_original => series_original, :series_local => series_local, :content_original => content_original, :content_local => content_local}
  end

  def custom_list_to_custom_properties(custom_list)
    eidr = ""
    series_number = ""
    custom_list.each do |custom|
      if custom.attributes['key'] == 'seasonId'
        eidr = custom.elements["propertyValue"].text
      end
      if custom.attributes['key'] == 'uniqueId'
        series_number = custom.elements["propertyValue"].text
      end
    end
    {:eidr => eidr, :series_number => series_number}
  end

  def content_data_for_content_ref_id(contents, content_ref_id)
    contents.each do |content|
      content_id = content.elements["contentId"].text
      if content_id == content_ref_id
        title_list = content.elements["titleList"]
        titles = title_list_to_titles(title_list)
        custom_list = content.elements["customPropertyList"]
        customs = custom_list_to_custom_properties(custom_list)
        the_year = content.elements["seasonNumber"]
        if the_year
          year_number = content.elements["seasonNumber"].text
        else
          year_number = ""
        end
        return {:titles => titles, :customs => customs, :year_number => year_number, :valid => true}
      end
    end
    return {:titles => {}, :customs => {}, :year_number => "", :valid => false}
  end


end

