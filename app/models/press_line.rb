class PressLine < ActiveRecord::Base
  
  belongs_to :channel
  belongs_to :press_filename
  has_many :press_line_automated_dynamic_special_joins
  has_many :automated_dynamic_specials, :through => :press_line_automated_dynamic_special_joins

  validates_presence_of :channel_id, :press_filename_id

  attr_accessor :checked

  def self.search(search, press_date, channel_name)

    channel = get_channel(channel_name)
    
    if search
      if press_date.blank?
        find(:all, :conditions => ['original_title LIKE ? and channel_id = ?', "%#{search}%", channel.id], :order => :start)
      else
        date = Date.parse(press_date).strftime('%F')
        find(:all, :conditions => ['original_title LIKE ? and DATE(start) = ? and channel_id = ?', "%#{search}%", date, channel.id], :order => :start)
      end
    else
      if press_date.blank?
        find(:all, :conditions => ['channel_id = ?', channel.id], :order => :start)
      else
        date = Date.parse(press_date).strftime('%F')
        find(:all, :conditions => ['DATE(start) = ? and channel_id = ?', date, channel.id], :order => :start)
      end
    end
  end 
  
  def self.find_by_start_and_channel(start, channel)
    
    find(:first, :conditions => ['start = ? and channel_id =?',start,channel.id])
    
  end
  
  
  def self.priority_and_lead(params)
    channel = get_channel(params[:channel])
    start_date = Date.parse(params[:priority_date]).strftime('%F')
    end_date = (Date.parse(params[:priority_date]) + params[:days].to_i.days).strftime('%F')
#    find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ?  and (priority = ? or LENGTH(lead_text) > 0)', start_date, end_date, channel.id, true], :order => :start)
    find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ? ', start_date, end_date, channel.id], :order => :start)
  end
  
  def self.priority_lines(show, priority_date, channel_name)
    
    channel = get_channel(channel_name)
    
    if priority_date.blank?
      date = Date.parse(Time.new().to_s) # midnight today
    else
      date = Date.parse(priority_date)
    end
    
    end_date = date + 6.days
    
    if show == 'Priority Only'
      find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ? and (priority = ? or audio_priority = ?)',
                                  date.strftime('%F'), end_date.strftime('%F'), channel.id, true, true], :order => :start)
    elsif show == 'All'
      find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ?',
                                date.strftime('%F'), end_date.strftime('%F'), channel.id], :order => :start)
    else
      find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ? and TIME(start) >= ?',
                                date.strftime('%F'), end_date.strftime('%F'), channel.id, "17:00:00"], :order => :start)
    end

  end

  def self.schedule_lines(show, priority_date, channel_name, checked_ids)
    
    channel = get_channel(channel_name)
    
    if priority_date.blank?
      date = Time.parse(Time.new.to_s(:broadcast_date_full_month)) # midnight today
    else
      date = Time.parse(priority_date)
    end
    
    start_time_30h = Time.utc(date.year, date.month, date.day, 6, 0, 0)
    end_time_30h = start_time_30h + 1.day - 1.second

    end_date = date
    
    if show == 'All'
      #results = find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ?',
       #                         date.strftime('%F'), end_date.strftime('%F'), channel.id], :order => :start)

      results = find :all, :conditions => ['start >= ? and start <= ? and channel_id =?', start_time_30h, end_time_30h, channel.id], :order => :start
    else
      results = find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ? and TIME(start) >= ?',
                                date.strftime('%F'), end_date.strftime('%F'), channel.id, "15:00:00"], :order => :start)
    end

    if checked_ids
      results.each do |result|
        if checked_ids.include? result.id.to_s
          result.checked = true
        else
          result.checked = false
        end
      end
    end

    results
    
  end

  def self.selected_programme(my_press_lines, my_programme)

    if my_press_lines.length == 0
      result = nil
    else
      result = my_press_lines[0].id.to_s
      my_press_lines.each do |press_line|
        if press_line.id.to_s == my_programme
          result = my_programme
        end
      end
    end
    result
  end

  def self.schedule_lines_for_xml(start_date, channel_name, num_days)
    channel = get_channel(channel_name)
    date = Date.parse(start_date)
    end_date = date + num_days.to_i.days
    find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ? and channel_id = ?',
                                  date.strftime('%F'), end_date.strftime('%F'), channel.id], :order => :start)

  end
  
  def self.schedule_filter
    filters = ['All', '15.00 - 23.59']
  end

  def specials
    press_line_automated_dynamic_special_joins
  end

  def self.programme_list(press_lines)
    result = []
    selected_text = ''
    press_lines.each do |press_line|
      display = press_line.start.strftime("%H:%M") + " - " + press_line.display_title
      result << [display, press_line.id.to_s]
    end
    result
  end

  def self.get_channel(channel_name)
    channel = Channel.find_by_name(channel_name)
    if channel.nil?
      channel = Channel.first
    end
    channel
  end
  
  def add_line(line, tab, last, channel, filename)
      element = line.split("\t")
      press = PressLine.new

      start_date = element[tab[:start_date].position-1]
      start_time = element[tab[:start_time].position-1]
      if start_date.empty?
        start_date = last.strftime("%Y-%m-%d")
        @start = increment_date(start_date_time(start_date, start_time), last)
      else
        @start = start_date_time(start_date, start_time)
      end
      
      press.start = @start
      press.display_title = element[tab[:display].position - 1].strip
      press.original_title = element[tab[:original].position - 1].strip
      press.channel = channel
      press.press_filename = filename
      press.lead_text = element[tab[:lead_text].position - 1].strip
      press.priority = Priority.priority(filename.id, @start)
      press.series_number = element[tab[:series_number].position - 1].strip
      press.year_number = element[tab[:year_number].position - 1].strip
      press.save
  end
  
  def add_line_clipsource(line, tab, last, channel, filename)
  		my_error = false
      if line
        element = line.split("\t")
				press = PressLine.new

        start_date = element[tab[:start_date].clipsource_position-1]
        start_time = element[tab[:start_time].clipsource_position-1]
        if start_date.empty?
          start_date = last.strftime("%Y-%m-%d")
          temp_start = increment_date(start_date_time(start_date, start_time), last)
        else
          temp_start = start_date_time(start_date, start_time)
          my_error = temp_start.nil?
        end
        
        if temp_start
          @start =  temp_start
          press.start = @start
          press.display_title = safe_strip(element[tab[:display].clipsource_position - 1])
          press.original_title = safe_strip(element[tab[:original].clipsource_position - 1])
          press.channel = channel
          press.press_filename = filename
          press.lead_text = safe_strip(element[tab[:lead_text].clipsource_position - 1])
          press.priority = Priority.priority(filename.id, @start)
          press.audio_priority = Priority.audio_priority(filename.id, @start)
          press.series_number = safe_strip(element[tab[:series_number].clipsource_position - 1])
          press.year_number = safe_strip(element[tab[:year_number].clipsource_position - 1])
          press.eidr = safe_strip(element[tab[:eidr].clipsource_position - 1])
        	if press.eidr.start_with?('SPORTS/') || press.eidr.start_with?('com.mtg.content.SPORTS/')
				 		press.eidr = safe_strip(element[tab[:sport].clipsource_position - 1])
				 	end         
				 	press.save
        else
          @start = last
        end
      end
      if my_error
      	nil
      else
      	true
      end
  end
  
  def add_event_clipsource_xml(start_time, content_def_id, channel, filename)
    my_error = false
    press = PressLine.new

    if start_time
      press.start = start_time
      press.channel = channel
      press.press_filename = filename
      press.lead_text = ""
      press.priority = Priority.priority(filename.id, start_time)
      press.audio_priority = Priority.audio_priority(filename.id, start_time)
      press.content_id = content_def_id
      if press.save then
        true
      else
        nil
      end
    end
  end

  def add_content_clipsource_xml(year_number, customs, titles, content_id)
    self.year_number = year_number
    self.series_number = customs[:series_number]
    is_sport = customs[:eidr].include?("SPORTS/")
    self.eidr = calculate_eidr(customs[:eidr], content_id, is_sport)
    title_hash = calculate_title(titles, is_sport)
    self.original_title = title_hash[:original_title]
    self.display_title = title_hash[:display_title]
    self.save
  end

  def add_clipsource_xml(start_time, content_def_id, channel, filename, content_data)
    if start_time
      self.start = start_time
      self.channel = channel
      self.press_filename = filename
      self.lead_text = ""
      self.priority = Priority.priority(filename.id, start_time)
      self.audio_priority = Priority.audio_priority(filename.id, start_time)
      self.content_id = content_def_id

      self.year_number = content_data[:year_number]
      customs = content_data[:customs]
      self.series_number = customs[:series_number]
      is_sport = customs[:eidr].include?("SPORTS/")
      self.eidr = calculate_eidr(customs[:eidr], content_def_id, is_sport)
      title_hash = calculate_title(content_data[:titles], is_sport)
      self.original_title = title_hash[:original_title]
      self.display_title = title_hash[:display_title]
    end
  end

  def calculate_eidr(eidr, content_id, is_sport)
    if eidr != "" && !is_sport
      return eidr
    else
      replacements = Clipsource.all
      replacements.each do |replace|
        if content_id.starts_with?(replace.from)
          return content_id.sub(replace.from, replace.to)
        end
      end
    end
    return content_id 
  end
  
  def calculate_title(titles, is_sport)
    display_title = ''
    if titles[:series_original] != ''
      original_title = titles[:series_original]
    else
      original_title = titles[:content_original]
    end
    if is_sport
      if titles[:series_local] != '' && titles[:content_local] != ''
        display_title = titles[:series_local] + ": " + titles[:content_local]
      end
    end
    if display_title == ''
      if titles[:series_local] != ''
        display_title = titles[:series_local]
      else
        display_title = titles[:content_local]
      end
    end
    {:original_title => original_title, :display_title => display_title}
  end

  def safe_strip(s)
    if s
      s.strip
    else
      s
    end
  end
  
  
  def channel_name
    if channel.nil?
      ""
    else
      channel.name
    end
  end
  
  def language
    if channel.nil?||channel.language.nil?
      ''
    else
      channel.language.name
    end
  end
  
  
  def priority_display
    if priority
      'Priority'
    else
      ''
    end
  end
  
  def audio_display
    if audio_priority
      'Audio'
    else
      ''
    end
  end
  
  def last_start_time
    @start
  end
  
  def date_offset
    @date_offset
  end
  
  def self.unique_dates
    press = find(:all, :order => :start)
    unique=[]
    last_date_part=DateTime.now
    press.each do |p|
      if not p.start.nil?
        current = p.start_date_part
        if last_date_part != current
          unique << current 
          last_date_part = current
        end
      end
    end
    unique
  end
  
  def start_date_part
    date_part(self.start)
  end
  
  def series_message
    if self.series_number
    	if !self.series_number.blank?
				if self.year_number.blank?
					if self.eidr.blank?
						self.series_number
					else
						self.series_number + ' EIDR: ' + self.eidr
					end
				else
					if self.eidr.blank?
						self.series_number + ' - Year: ' + self.year_number
					else
						self.series_number + ' - Year: ' + self.year_number + ' EIDR: ' + self.eidr
					end
				end
			else
				if self.eidr.blank?
					if self.year_number.blank?
						' '
					else
						'Year: ' + self.year_number
					end
				else
					if self.year_number.blank?
						'EIDR: ' + self.eidr
					else
						'Year: ' + self.year_number + ' EIDR: ' + self.eidr
					end
				end
			end
		else
		 ' '
		end
  end
  
  def comparison_code(house_number, contained)
		h = House.find_by_house_number(house_number)
    if h && h.series_ident then
      local = h.series_ident.title.local_title(language)||""
			if h.series_ident.number == series_number||h.series_ident.eidr == eidr
				if h.series_ident.year_number == year_number
					if h.series_ident.title.english == original_title
						if local.blank?
							:in_db_local_blank
						elsif local == display_title
							if h.series_ident.eidr.blank?
								:in_db_no_eidr
							else
								:in_db
							end
						else
							:in_db_fix_local
						end
					else
						:in_db_fix_english
					end
				elsif h.series_ident.title.english == original_title
					:in_db_fix_year
				else
					:in_db_fix_english_year
				end
			else
				s = SeriesIdent.find_by_number(series_number)
				if s
					:in_db_house_series_mismatch
				else
					:in_db_fix_series
				end
			end
			#else
			#	:in_db_fix_series
			#end			
    else
    	s = SeriesIdent.find_by_eidr(eidr)
    	if s.nil? && !series_number.blank?
    		s = SeriesIdent.find_by_number(series_number)
    	end
      if s
        if s.year_number == year_number
          if s.title
            if s.title.english == original_title
              local = s.title.local_title(language)||""
              if local.blank? 
                :not_db_local_blank
              elsif local == display_title
                :not_db_all_match
              else
                :not_db_fix_local
              end
            else
							:not_db_fix_english
            end
          else
            :not_db_fix_english
          end
        else
          if s.title.english == original_title
            :not_db_fix_year
          else
            :not_db_fix_english_year
          end
        end
      else
        t = Title.find_all_by_english(original_title)
        if t.size == 0
          if contained
            :not_db_no_match_contained
          else
            :not_db_no_match
          end
        elsif t.size == 1
          ti = t.first
          local = ti.local_title(language)||""
          if local.blank?
            result = :not_db_no_series_local_blank
          elsif local == display_title
            result = :not_db_no_series
          else
            result = :not_db_no_series_fix_local
          end
          result          
        else # multiple titles match
          result = :not_db_no_series_fix_local_multiple
          t.each do |ti|
            local = ti.local_title(language)||""
            if local.blank? && result == :not_db_no_series_fix_local_multiple
              result = :not_db_no_series_local_blank_multiple
            elsif local == display_title
              result = :not_db_no_series_multiple
            end
          end
          result
        end
      end
    end
  end

  def self.update_press_title_with_stored(press_id, language)
    press = find_by_id(press_id)
    title = Title.find_by_english(press.original_title)
    update_press_titles(press_id, language, title)
  end
    
  def self.update_press_titles(press_id, language, title)
    press = find_by_id(press_id)
    if press
      local_title = title.local_title(language)
      press.display_title = local_title unless local_title.blank?
      press.original_title = title.english unless title.english.blank?
      if !press.save
        notice = 'Issue with updating press title. '
        success = false
        issues = 1
        added = 0
      else
        success = true
        added = 1
        issues = 0
      end
    else
      notice = 'Issue with updating press title. '
      success = false
      issues = 1
      added = 0
    end
    {:notice => notice, :success => success, :added => added, :issues => issues}
  end
  
  def self.count_message(press_lines)
    count = 0
    if press_lines
      press_lines.each do |press_line|
        count = count + press_line.specials.length
      end
    end
    if count == 0
      message = "0 specials scheduled"
    elsif count == 1
      message = "1 special scheduled"
    else
      message = count.to_s + " specials scheduled"
    end
    message
  end  

  def self.random_generate_message(params)
    start_date = Time.parse(params[:start_date])
    end_date = Time.parse(params[:end_date])
    start_time = validate_30h_time(params[:start_time])
    end_time = validate_30h_time(params[:end_time])
    if params[:part_ids] 
      parts = Part.find(params[:part_ids])
    end
    minimum_gap = params[:minimum_gap]
    replace = params[:replace]

    if params[:automated_dynamic_special_ids]
      specials = AutomatedDynamicSpecial.find(params[:automated_dynamic_special_ids])
    end

    message = ''
    one_day = false
    issue = false
    issue_message = ''
    if start_date == end_date
      message = 'The random scheduling will be for ' + start_date.to_s(:broadcast_date) + ".\n" 
      one_day = true
    else
      if start_date > end_date
        issue = true
        issue_message = 'Start date cannot be after end date.' + "\n"
      else
        message = 'The random scheduling will be from ' + start_date.to_s(:broadcast_date) + ' to ' + end_date.to_s(:broadcast_date) + ".\n"
      end
    end
    if !start_time[:valid]
      issue = true
      issue_message = issue_message + 'Start time: ' + start_time[:message] + ".\n"
    end
    if !end_time[:valid]
      issue = true
      issue_message = issue_message + 'End time: ' + end_time[:message] + ".\n"
    end
    if start_time[:valid] && end_time[:valid]
      if start_time[:next_day] 
        test_start_time = start_time[:time] + 1.day
      else
        test_start_time = start_time[:time]
      end
      if end_time[:next_day] 
        test_end_time = end_time[:time] + 1.day
      else
        test_end_time = end_time[:time]
      end

      if test_start_time < test_end_time
        if one_day
          message = message + 'The generate will be between: ' + test_start_time.to_s(:broadcast_hm) + ' to ' + test_end_time.to_s(:broadcast_hm) + ".\n"
        else
          message = message + 'The generate will be between: ' + test_start_time.to_s(:broadcast_hm) + ' to ' + test_end_time.to_s(:broadcast_hm) + ' (on each day).' + "\n"
        end
      else
        issue = true
        issue_message = issue_message + 'Start time must be before end time' + ".\n"
      end
    end
    if parts.nil? || parts.length == 0
      issue = true
      issue_message = issue_message + 'No parts selected.' + "\n"
    else
      if parts.length == 1
        message = message + 'The generate will happen on this part: ' + ".\n"
      else
        message = message + 'The generate will happen on these parts: ' + ".\n"
      end
      parts.each do |part|
        message = message + part.name + ", "
      end
      message = message[0, message.length - 2] + ".\n"
    end

    if minimum_gap.nil? || minimum_gap == 0
      message = message + 'There is no minimum gap' + ".\n"
    else
      message = message + 'Minimum gap: ' + minimum_gap + ' minutes' + ".\n"
    end

    if replace.nil?
      message = message + 'Existing specials will be kept' + ".\n"
    else
      message = message + 'Existing specials will be replaced' + ".\n"
    end

    if specials.nil? || specials.length == 0
      issue = true
      issue_message = issue_message + 'No specials selected for the generate' + ".\n"
    else
      if specials.length == 1
        message = message + 'This special will be used for the generate:' + ".\n"
      else
        message = message + 'These specials will be used for the generate:' + ".\n"
      end
      specials.each do |special|
        message = message + special.name + ".\n"
      end
    end
    
    if issue
      {:message => issue_message, :issue => true}
    else
      {:message => message, :issue => false }
    end

  end

  def self.validate_30h_time(my_time)
    #Expects string HH:MM - returns time object if OK
    elements = my_time.split(':')
    message = ''
    if elements.length > 1
      if valid_integer_between(elements[1], 0, 59)
        if valid_integer_between(elements[0], 6, 23)
          result_time = Time.utc(0, 1, 1, elements[0].to_i, elements[1].to_i, 0)
          next_day = false
          valid = true
        elsif valid_integer_between(elements[0], 24, 29)
          result_time = Time.utc(0, 1, 1, elements[0].to_i - 24, elements[1].to_i, 0)
          next_day = true
          valid = true
        else
          result_time = nil
          next_day = false
          valid = false
          message = "Hours should be between 06 and 29"
        end
      else
        result_time = nil
        next_day = false
        valid = false
          message = "Hours should be between 06 and 29 and minutes between 0 and 59"
      end
    else
      result_time = nil
      next_day = false
      valid = false
      message = "Not a valid time. It should be between 06:00 and 29:59"
    end
    {:time => result_time, :valid => valid, :next_day => next_day, :message => message}
  end

  def self.valid_integer_between(number_string, lower, upper)
    if number_string.match(/^(\d)+$/).present? #integer?
      number = number_string.to_i
      number >= lower && number <= upper
    else
      false
    end
  end

  def self.randomly_schedule(params)

    start_date = Time.parse(params[:start_date])
    end_date = Time.parse(params[:end_date])
    start_time_obj = validate_30h_time(params[:start_time])
    end_time_obj = validate_30h_time(params[:end_time])
    channel = get_channel(params[:channel])

    the_date = start_date
    my_dates = []
    while the_date <= end_date
      my_dates << the_date
      the_date = the_date + 1.day
    end

    parts = nil
    if params[:part_ids]
      parts = Part.find(params[:part_ids])
    end

    replace = params[:replace].present?

    automated_dynamic_specials = nil
    if params[:automated_dynamic_special_ids]
      automated_dynamic_specials = AutomatedDynamicSpecial.find(params[:automated_dynamic_special_ids])
    end

    minimum_gap = params[:minimum_gap].to_i
    final_results =[]

    count_added = 0
    count_updated = 0
    results = nil
    my_dates.each do |date|
      the_times = start_and_end_datetimes(date, start_time_obj, end_time_obj)
      if the_times[:valid]
        results = find(:all, :conditions => ['start >= ? and start <= ? and channel_id = ?', (the_times[:start_date_time]-1.hour).to_s(:db), (the_times[:end_date_time]+ 1.hour).to_s(:db), channel.id ], :order => :start)
        if results && parts
          results.each do |result|
            message = []
            message << "Press Line #{result.start.to_s(:broadcast_datetime)}: #{result.display_title}"
            parts.each do |part|
              part_tx = Part.special_tx_time_from_ids(result.id, part.id)
              if part_tx[:valid_part]
                part_tx_time = part_tx[:time]
                if part_tx_time && part_tx_time < the_times[:end_date_time] && part_tx_time >= the_times[:start_date_time]
                  message << "Doing #{part.name}"
                  specials = PressLineAutomatedDynamicSpecialJoin.find_all_by_press_line_id_and_part_id(result.id , part.id)
                  message << "There are currently #{specials.length} on this part"
                  if specials.length > 1
                    for index in (specials.length-1).downto(1) do
                      specials[index].destroy
                    end
                  end
                  specials = PressLineAutomatedDynamicSpecialJoin.find_all_by_press_line_id_and_part_id(result.id , part.id)
                  do_this_press_line = true
                  if specials.length == 1
                    do_this_press_line = replace
                  end
                  message << "Are we doing this press line: #{do_this_press_line}"
                  if do_this_press_line
                    message << "The minimum gap is #{minimum_gap} minutes"
                    poss = valid_specials(result, automated_dynamic_specials, minimum_gap, part)
                    possible_specials = poss[:result]
                    message += poss[:message]
                    message << "There are #{possible_specials.length} possible specials"
                    if possible_specials.length > 0
                      special_to_add = possible_specials[rand(possible_specials.length)]
                      message << "Special to add: #{special_to_add.name}"
                      updated = false
                      if specials.length == 1
                        special_join = specials[0]
                        updated = true
                      else
                        special_join = PressLineAutomatedDynamicSpecialJoin.new
                      end
                      special_join.press_line_id = result.id
                      special_join.automated_dynamic_special_id = special_to_add.id
                      special_join.part_id = part.id
                      special_join.offset = special_to_add.offset
                      special_join.tx_time = part_tx_time
                      if special_join.save
                        if updated
                          count_updated += 1
                          message << "Special updated"
                        else
                          count_added += 1
                          message << "Special added"
                        end
                      else
                        message << 'Issue saving special'
                      end
                    end
                  end
                else
                  if part_tx_time
                    if part_tx_time >= the_times[:end_date_time]
                      message << "Not doing: #{part.name} due to part time: #{part_tx_time.to_s(:broadcast_datetime)} being after the last scheduled time: #{the_times[:end_date_time].to_s(:broadcast_datetime)}"
                    else
                      message << "Not doing: #{part.name} due to part time: #{part_tx_time.to_s(:broadcast_datetime)} being before the first scheduled time: #{the_times[:start_date_time].to_s(:broadcast_datetime)}"
                    end
                  else
                    message << "Not doing: #{part.name} as this doesn't exist on this programme length"
                  end
                end
              else
                message << "Not doing: #{part.name} due to invalid part number due to programme duration."
              end
            end
            final_results << message
          end
        end
      end
    end
    short_message = ""
    if count_added == 0 && count_updated == 0
      short_message = 'No specials added or updated'
    elsif count_added == 1 && count_updated == 0
      short_message = '1 special added'
    elsif count_added > 1 && count_updated == 0
      short_message = "#{count_added} specials added"
    elsif count_added == 1 && count_updated == 1
      short_message = '1 special added and 1 updated'
    elsif count_added == 1 && count_updated > 1
      short_message = "1 special added and #{count_updated} updated"
    elsif count_added == 0 && count_updated == 1
      short_message = '1 special updated'
    elsif count_added == 0 && count_updated > 1
      short_message = "#{count_updated} specials updated"
    elsif count_added > 1 && count_updated >= 1
      short_message = "#{count_added} specials added and #{count_updated} updated"
    else
      short_message = "Bad message #{count_added} and #{count_updated}"
    end
    {:short_message => short_message, :notes =>final_results}

  end

  def self.start_and_end_datetimes(date, start_time_obj, end_time_obj)
    valid = true
    if start_time_obj[:valid] 
      start_date_time = Time.utc(date.year, date.month, date.day, start_time_obj[:time].hour, start_time_obj[:time].min, start_time_obj[:time].sec)
      if start_time_obj[:next_day]
        start_date_time = start_date_time + 1.day
      end
    else
      valid = false
    end
    if end_time_obj[:valid]
      end_date_time = Time.utc(date.year, date.month, date.day, end_time_obj[:time].hour, end_time_obj[:time].min, end_time_obj[:time].sec)
      if end_time_obj[:next_day]
        end_date_time = end_date_time + 1.day
      end
    else
      valid = false
    end
    {:start_date_time => start_date_time, :end_date_time => end_date_time, :valid => valid}
  end

  def self.valid_specials(press_line, automated_dynamic_specials, minimum_gap, part)
    results = []
    message =[]
    automated_dynamic_specials.each do |ads|
      if ads.first_use <= press_line.start && ads.last_use >= press_line.start
        part_tx = Part.special_tx_time_from_ids(press_line.id, part.id)
        if part_tx[:valid_part]
          part_tx_time = part_tx[:time]
          if part_tx_time.present?
            last_time_difference = PressLineAutomatedDynamicSpecialJoin.time_difference_last_placing(ads.id, part_tx_time)
            if last_time_difference.present?
              if last_time_difference >= minimum_gap
                results << ads
              else
                message << "#{ads.name} excluded for minimum gap. #{last_time_difference} minutes"
              end
            else
              message << "#{ads.name} excluded for no last time"
            end
          else
            message << "#{ads.name} excluded for no part time"
          end
        else
            message << "#{ads.name} excluded for invald part number"
        end
      else
        message << "#{ads.name} excluded for first/last use date"
      end
    end
    {:result => results, :message => message}
  end

  def next_programme
    PressLine.find :first, :conditions => ['channel_id = ? and start > ?', self.channel_id, self.start], :order => :start
  end

  def duration_minutes
    next_prog = next_programme
    if next_prog
      (next_prog.start - self.start)/60
    else
      60.0
    end
  end

  private
  def start_date_time (start_date, start_time)
    # Expects start_date to be a string in the format yyyy-mm-dd
    # Expects start_time to be a string in the format hh:mm:ss:ff
    
    if start_date && start_time
			DateTime.strptime(start_date+start_time,"%Y-%m-%d%H:%M") 
		else
			nil
		end
    
  rescue ArgumentError
    nil
  end
  
  
  def increment_date(current, last)
    if current.hour<10 and last.hour>10
      current + 1.days
    else
      current
    end
  end
  
  
  def date_part(t)
    DateTime.new(t.year,t.month,t.day)
  end
  
  
end
