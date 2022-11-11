class Title < ActiveRecord::Base
  
  has_many :houses, :dependent => :delete_all
  has_many :promos, :dependent => :delete_all
  has_many :series_idents, :dependent => :delete_all
  has_many :cross_channel_priorities, :dependent => :delete_all
  
  validates_presence_of :english
  default_scope :order => :english
  
  attr_accessor :source
  attr_accessor :channel
  attr_accessor :schedule_comparison_id
  attr_accessor :press_line_id
  attr_accessor :language
      
  def self.search(search, page)
    if search
      paginate  :per_page => 12, :page =>page,
                :conditions => ['english LIKE ?', "%#{search}%"]
    else
      paginate  :per_page => 12, :page =>page
    end
  end
  def self.search_eidr(search, page)
    if search
      mum = paginate(:per_page => 12, :page =>page,
                :joins => :series_idents,
                :conditions => ['series_idents.eidr LIKE ?', "%#{search}%"])
      mum.uniq
    else
      paginate  :per_page => 12, :page =>page
    end
  end
  
  def self.search_types
    ['English Title','EIDR']
  end

    
  def eop_display
    if eop
      "Own"
    else
      "None"
    end
  end
  
  def eop_boolean
    if eop
      "True"
    else
      "False"
    end
  end   
  
  def has_language?(language_name)
    case language_name
    when "Danish"
      not danish.blank?
    when "Swedish"
      not swedish.blank?
    when "Hungarian"
      not hungarian.blank?
    when "Norwegian"
      not norwegian.blank?
    else
      false
    end
    
  end
  
  def local_title(language_name)
    case language_name
    when "Danish"
      danish
    when "Swedish"
      swedish
    when "Hungarian"
      hungarian
    when "Norwegian"
      norwegian
    else
      ""
    end
  end
  
  def add_promo(promo_id)
    p = Promo.find(promo_id)
    num = 0
    if p
      series_idents.each do |s|
        found = false
        s.promos.each do |pr|
          found = true if pr == p
        end
        s.promos << p unless found
        num += 1 unless found
      end
      if num == 0
        'Already added. '
      elsif num ==1 
        'Added to 1 series ident. '
      else
        'Added to ' + num.to_s + ' series idents. '
      end
    else
      'Promo not found. '
    end
  end
  
  def set_discrepancy(comparison)
    english = comparison.original_title
    case comparison.channel.language_name 
    when 'Danish'
      danish = danish_title
    when 'Swedish'
      swedish = danish_title
    when 'Hungarian'
      hungarian = danish_title
    when 'Norwegian'
      norwegian = danish_title
    end
  end

  def self.add_series_and_house(comparison_id, comparison_type, eop)
    if comparison_type == 'schedule_comparison'
      comparison = ScheduleComparison.find_by_id(comparison_id)
    else
      comparison = Comparison.find_by_id(comparison_id)
    end
	
    notice = ''
    added = 0
    title_added =0
    house_added = 0
    promo_added = 0
    local_added = 0
    issues = 0
    title_issues = 0
    house_issues = 0
    local_issues = 0
    success = false
    continue = false
    create_title = false
    if comparison
      code = comparison.comparison_code.to_sym
      
      case code
      when *[:not_db_no_match_contained, :not_db_no_match]
        #does house number already exist from other route
        house = House.find_by_house_number(comparison.house_number)
        if house.nil?
          eidr = SeriesIdent.find_by_eidr(comparison.eidr)
          if !eidr.nil?
            #This has an already existing eidr
            eidr_title = eidr.title
            if eidr_title.english == comparison.original_title && eidr_title.local_title(comparison.channel.language.name) == comparison.local_title
              #The eidr is the same title. No need to create a new one
              continue = true
            else
              create_title = true
            end
          else
            #eidr is null but lets see if the title already exists
            if !find_by_english(comparison.original_title)
              create_title = true
            end
          end
          if create_title
            continue = true
            @title = Title.new
            @title.english = comparison.original_title
            if eop
              @title.eop = true
            else
              @title.eop = false
            end
            if @title.save
              title_added += 1
            else
              @title.errors.each do |e|
                notice += e.to_s.capitalize + ". "
                title_issues += 1
              end
            end
          end
        else
          notice += "Possible same programme ticked more than once as house number already present: #{comparison.house_number} - #{comparison.original_title}. "    
        end
      else
        continue = true
      end
      
      if continue
        case code
        when *[:not_db_no_series, :not_db_no_series_local_blank, :not_db_no_match_contained, :not_db_no_match, :not_db_local_blank]
          @title = find_by_english(comparison.original_title)
          case code
          when *[:not_db_no_series_local_blank, :not_db_no_match_contained, :not_db_no_match, :not_db_local_blank]
            stats = set_local_title(comparison.local_title, comparison.channel)
            local_added += stats[:added]
            local_issues += stats[:issues]
            notice += stats[:notice]
            if stats[:do_save]
              @title.save
            end
          end
          press = PressLine.find(comparison.press_id)
          logger.debug "1PPPP"
          logger.debug press
          s = SeriesIdent.find_by_title_id_and_year_number(@title.id, press.year_number)
          logger.debug s
          if s
            if s.eidr.blank? 
              s.eidr = press.eidr
            elsif s.eidr != press.eidr
              s = SeriesIdent.new
              s.update_info(@title.id, comparison.press_id)
            end
          else
            s = SeriesIdent.new
            s.update_info(@title.id, comparison.press_id)
          end
          if s.save
            added += 1
            stats = House.add_from_comparison(comparison_id, comparison_type)
            success = stats[:success]
            house_added += stats[:added]
            house_issues += stats[:issues]
            notice += stats[:notice]
            promo_added += stats[:promo_added]
          else
            s.errors.each do |e|
              notice += e.to_s.capitalize + ". "
              issues += 1
            end
          end
        else
          notice += 'Wrong type of add'
          issues += 1
        end
      end
    end
    {:added => added, :house_added => house_added, :issues => issues, :house_issues => house_issues, :promo_added => promo_added,
      :local_added => local_added, :local_issues => local_issues, :title_added => title_added, :title_issues => title_issues,
      :notice => notice, :success => success}  
  end  
  
  def self.add_local_title(comparison_id, source)
    if source == 'schedule_comparison'          
      comparison = ScheduleComparison.find_by_id(comparison_id)
    else
      comparison = Comparison.find_by_id(comparison_id)
    end
    if comparison.series_ident != ""
      s = SeriesIdent.find_by_number(comparison.series_ident)
    else
      if comparison.eidr != ""
        s = SeriesIdent.find_by_eidr(comparison.eidr)
      end
    end
    if s
      code = comparison.comparison_code.to_sym 
      case code
      when *[:in_db_local_blank, :not_db_local_blank]
      	if s.eidr.blank?
      		s.eidr = comparison.eidr
      		s.save
				end
        @title = s.title
        if @title
          stats = set_local_title(comparison.local_title, comparison.channel)
          if stats[:do_save]
            @title.save
          end
          stats
        else
          {:added => 0, :issues => 1, :notice => 'Cannot find title'}
        end
      else
        {:added => 0, :issues => 1, :notice => 'Cannot find record'}
      end
    else
      {:added => 0, :issues => 1, :notice => 'Cannot find title'}
    end
  end

  def self.add_local_title_and_house(comparison)
    if comparison.eidr != ""
      s = SeriesIdent.find_by_eidr(comparison.eidr)
    else
      if comparison.series_ident != ""
        s = SeriesIdent.find_by_number(comparison.series_ident)
      end
    end
    if s
      code = comparison.comparison_code.to_sym 
      case code
      when *[:in_db_local_blank, :not_db_local_blank]
      	if s.eidr.blank?
      		s.eidr = comparison.eidr
      		s.save
				end
        @title = s.title
        if @title
          stats = set_local_title(comparison.local_title, comparison.channel)
          #{:added => added, :issues => issues, :notice => notice, :do_save => do_save}
          if stats[:do_save]
            @title.save
            #Now add the house
            house = House.find_or_create_by_house_number(comparison.house_number)
            house.series_ident = s
            house.house_number = comparison.house_number
            house.title = s.title
            if house.save
              stats[:house_added] = 1
            else
              house.errors.each_full do |err|
                if err.upcase != "HOUSE NUMBER  IS ALREADY IN THE SYSTEM"
                  logger.debug "============>" + err.upcase
                  stats[:issues] += 1
                  stats[:notice] += err + ". "
                end
              end
            end
          end
          stats
        else
          {:added => 0, :issues => 1, :notice => 'Cannot find title'}
        end
      else
        {:added => 0, :issues => 1, :notice => 'Cannot find record'}
      end
    else
      {:added => 0, :issues => 1, :notice => 'Cannot find title'}
    end
  end

  def self.add_from_comparison(comparison)
    notice = ''
    added = 0
    house_added = 0
    issues = 0
    house_issues = 0
    success = false
    if not comparison[:found]
      notice += comparison[:title] + ' has no title to add to database. '
      issues += 1
    else 
      if comparison[:found_house] 
        notice += 'Title and House No: ' + comparison[:house_number] + ' already in database. '
        issues += 1
      else
        h = House.find_by_house_number(comparison[:house_number])
        if h then
          #if we get here, we've found a house number and we'll add the local title to the title record
          @title = find(h.title_id)
          stats = set_local_title(comparison[:local_title], comparison[:channel])
          notice += stats[:notice]
          issues += stats[:issues]
          if stats[:do_save]
            if @title.save
              added +=1
              success = true
            else
              @title.errors.each_full do |err|
                issues += 1
                notice += err + ". "
              end
            end
          else
            success = true
          end
        else
          #if we get here, there is no associated house number
          @title = find_by_english(comparison[:original_title])
          
          if @title
            stats = set_local_title(comparison[:local_title], comparison[:channel])
            notice += stats[:notice]
            issues += stats[:issues]
            if stats[:do_save]
              if @title.save
                added +=1
                stats = House.add_from_comparison comparison, @title
                notice += stats[:notice]
                house_added += stats[:added]
                house_issues += stats[:issues]
                success = stats[:success]
              else
                @title.errors.each_full do |err|
                  issues += 1
                  notice += err + ". "
                end
              end
            else
              stats = House.add_from_comparison comparison, @title
              notice += stats[:notice]
              house_added += stats[:added]
              house_issues += stats[:issues]
              success = stats[:success]  
            end
            
          else
            #if we get here we need to create a new title
            @title = new
            @title.english = comparison[:original_title]
            stats = set_local_title(comparison[:local_title], comparison[:channel])
            notice += stats[:notice]
            issues += stats[:issues]
            if @title.save
              added += 1
              stats = House.add_from_comparison comparison, @title
              notice += stats[:notice]
              house_added += stats[:added]
              house_issues += stats[:issues]
              success = stats[:success]
            else
              @title.errors.each_full do |err|
                issues += 1
                notice += err + ". "
              end
            end
          end
        end
      end
    end
    {:added => added, :house_added => house_added, :issues => issues, :house_issues => house_issues, 
      :notice => notice, :success => success}
  end
  
  def self.set_local_title(local_title, channel)
    issues = 0
    added = 0
    notice = ''
    case channel.language.name
    when 'Danish'
      if @title.danish && (!(@title.danish.empty?))
        do_save = false
        if @title.danish != local_title
          issues = 1
          notice = 'Danish title different from stored. Original title: ' + @title.danish + ". New title: " + local_title + '. Original kept. '
        end
      else
        @title.danish = local_title
        added = 1
        do_save = true
      end
    when 'Swedish'
      if @title.swedish && (!(@title.swedish.empty?))
        do_save = false
        if @title.swedish != local_title
          issues = 1
          notice = 'Swedish title different from stored. Original title: ' + @title.swedish + ". New title: " + local_title + '. Original kept. '
        end
      else
        @title.swedish = local_title
        added = 1
        do_save = true
      end
    when 'Hungarian'
      if @title.hungarian && (!(@title.hungarian.empty?))
        do_save = false
        if @title.hungarian != local_title
          issues = 1
          notice = 'Hungarian title different from stored. Original title: ' + @title.hungarian + ". New title: " + local_title + '. Original kept.'
        end
      else
        @title.hungarian = local_title
        added =1
        do_save = true
      end
    when 'Norwegian'
      if @title.norwegian && (!(@title.norwegian.empty?))
        do_save = false
        if @title.norwegian != local_title
          issues = 1
          notice = 'Norwegian title different from stored. Original title: ' + @title.norwegian + ". New title: " + local_title + '. Original kept. '
        end
      else
        @title.norwegian = local_title
        added = 1
        do_save = true
      end
    end
    {:added => added, :issues => issues, :notice => notice, :do_save => do_save}
  end
  
  def self.add_from_schedule_comparison(line)
    comparison = {
      :found => line.found?,
      :house_found => line.found_house,
      :house_number => line.house_number,
      :title => line.title,
      :original_title => line.original_title,
      :local_title => line.local_title,
      :series_number => line.series_number,
      :channel => line.channel
    }
    add_from_comparison comparison
  end
  
  def self.add_from_playlist_comparison(line)
    comparison = {
      :found => line.found?,
      :house_found => line.found_house,
      :house_number => line.house_no,
      :title => line.long_title,
      :original_title => line.original_title,
      :local_title => line.danish_title,
      :series_number => nil,
      :channel => line.channel
    }
    add_from_comparison comparison
  end
      
  def self.add_dummy
    
    all_titles = all 
    all_titles.each do |t|
      if t.series_idents.count == 0
        SeriesIdent.create_new_dummy(t.id)
      end
    end
    
  end
  
  def self.language_specific(language_name)
    case language_name
      when 'Danish'
        find(:all, :include => :houses, :conditions => ['danish <> ""'])
      when 'Swedish'
        find(:all, :include => :houses, :conditions => ['swedish <> ""'])
      when 'Norwegian'
        find(:all, :include => :houses, :conditions => ['norwegian <> ""'])
      when 'Hungarian'
        find(:all, :include => :houses, :conditions => ['hungarian <> ""'])
      else
        find(:all, :include => :houses)
    end
  end

  def self.language_specific_and_updated_after(params)
    case params[:lang]
      when 'Danish'
        if params[:updated_after]
          updated_after_date = Date.parse(params[:updated_after]).strftime('%F')
          #find(:all, :include => :houses, :conditions => ['danish <> "" AND DATE(updated_at) >= ?', updated_after_date])
          find(:all, :select => 'DISTINCT(titles.id), titles.*', :joins => {:series_idents => :houses}, :conditions => ['danish <> "" AND (DATE(houses.updated_at) >= ? OR DATE(titles.updated_at) >= ? OR DATE(series_idents.updated_at) >= ?)',updated_after_date, updated_after_date, updated_after_date])
        else
          find(:all, :include => :houses, :conditions => ['danish <> ""'])
        end
      when 'Swedish'
        if params[:updated_after]
          updated_after_date = Date.parse(params[:updated_after]).strftime('%F')
          #find(:all, :include => :houses, :conditions => ['swedish <> "" AND DATE(updated_at) >= ?', updated_after_date])
          find(:all, :select => 'DISTINCT(titles.id), titles.*', :joins => {:series_idents => :houses}, :conditions => ['swedish <> "" AND (DATE(houses.updated_at) >= ? OR DATE(titles.updated_at) >= ? OR DATE(series_idents.updated_at) >= ?)',updated_after_date,updated_after_date, updated_after_date])
        else
          find(:all, :include => :houses, :conditions => ['swedish <> ""'])
        end
      when 'Norwegian'
        if params[:updated_after]
          updated_after_date = Date.parse(params[:updated_after]).strftime('%F')
          #find(:all, :include => :houses, :conditions => ['norwegian <> "" AND DATE(updated_at) >= ?', updated_after_date])
          find(:all, :select => 'DISTINCT(titles.id), titles.*', :joins => {:series_idents => :houses}, :conditions => ['norwegian <> "" AND (DATE(houses.updated_at) >= ? OR DATE(titles.updated_at) >= ? OR DATE(series_idents.updated_at) >= ?)',updated_after_date,updated_after_date, updated_after_date])
        else
          find(:all, :include => :houses, :conditions => ['norwegian <> ""'])
        end
      when 'Hungarian'
        if params[:updated_after]
          updated_after_date = Date.parse(params[:updated_after]).strftime('%F')
          #find(:all, :include => :houses, :conditions => ['hungarian <> "" AND DATE(updated_at) >= ?', updated_after_date])
          find(:all, :select => 'DISTINCT(titles.id), titles.*', :joins => {:series_idents => :houses}, :conditions => ['hungarian <> "" AND (DATE(houses.updated_at) >= ? OR DATE(titles.updated_at) >= ? OR DATE(series_idents.updated_at) >= ?)',updated_after_date,updated_after_date, updated_after_date])
        else
          find(:all, :include => :houses, :conditions => ['hungarian <> ""'])
        end
      else
        if params[:updated_after]
          updated_after_date = Date.parse(params[:updated_after]).strftime('%F')
      #    find(:all, :include => :houses, :conditions => ['DATE(updated_at) >= ?', updated_after_date])
          find(:all, :select => 'DISTINCT(titles.id), titles.*', :joins => {:series_idents => :houses}, :conditions => ['DATE(houses.updated_at) >= ? OR DATE(titles.updated_at) >= ? OR DATE(series_idents.updated_at) >= ?',updated_after_date,updated_after_date, updated_after_date])
        else
          find(:all, :include => :houses)
        end
    end
  end

  def self.find_eidr(eidr)
  	find(:all, :include => :series_idents, :conditions => ["series_idents.eidr = ?", eidr])  
	end

  def self.new_title_from_multiple(comparison)
    press = PressLine.find(comparison.press_id)
    channel = Channel.find_by_id(comparison.channel_id)
    message = ''
    created = 0
    issues = 0
    house_issues = 0
    title_issues = 0
    if !(press.nil?) && !(channel.nil?)
      title = Title.new
      title.english = press.original_title
      title.local_title_for_multiple(channel, press.display_title)  
      title.eop = true
      if title.save
        series_ident_stuff = title.new_series_ident_for_multiple(press.id)
        message += series_ident_stuff[:message]
        if series_ident_stuff[:success]
          new_house_number_stuff = title.new_house_number_for_multiple(comparison, series_ident_stuff[:series_ident])
          message += new_house_number_stuff[:message]
          if new_house_number_stuff[:success]
            created += 1
          else
            issues += 1
            house_issues += 1
          end
        else
          issues += 1
        end
      else
        issues += 1
        title_issues += 1
        message += "Title error: #{title.english}. "
        title.errors.each_full do |err|
          message += err + ". "
        end
      end
    end
    {:created => created, :issues => issues, :house_issues => house_issues, :title_issues => title_issues, :notice => message }
  end

  def local_title_for_multiple(channel, local_title)
    case channel.language.name
    when 'Danish'
      self.danish = local_title
    when 'Swedish'
      self.swedish = local_title
    when 'Hungarian'
      self.hungarian = local_title
    when 'Norwegian'
      self.norwegian = local_title
    end
  end

  def new_series_ident_for_multiple(press_line_id)
    message = ''
    if press_line_id
      s = SeriesIdent.new
      s.update_info(self.id, press_line_id)
      if s.save
        success = true
      else
        message = "Unable to create series ident"
        s.errors.each_full do |err|
          message += err + ". "
        end
        success = false
      end
      {:series_ident => s, :success => success, :message => message}
    end
    
  end

  def new_house_number_for_multiple(comparison, series_ident)
    h = House.find_or_create_by_house_number(comparison.house_number)
		h.series_ident = series_ident
		h.house_number = comparison.house_number
		h.title = self
    added = 0
    issues = 0
    message = ""
		if h.save
      added += 1
      success = true
		else
      success = false
      message += "House Number error. "
      h.errors.each_full do |err|
        if err.upcase != "HOUSE NUMBER  IS ALREADY IN THE SYSTEM"
          logger.debug "============>" + err.upcase
          issues += 1
          message += err + ". "
        end
      end
    end
    {:house => h, :success => success, :message => message}
  end


end
