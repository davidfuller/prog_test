class TitlesController < ApplicationController
  # GET /titles
  # GET /titles.xml
  def index
    
    respond_to do |format|
      format.html { index_html(params)}
      #format.xml { @titles = Title.all(:include => :houses) } 
      format.xml { 
        if params[:updated_after]  
          @titles = Title.language_specific_and_updated_after(params)
        else
          @titles = Title.language_specific(params[:lang])
        end  }
    end
  end

  # GET /titles/1
  # GET /titles/1.xml
  def show
    @title = Title.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @title }
    end
  end

  # GET /titles/new
  # GET /titles/new.xml
  def new
    @title = Title.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @title }
    end
  end
  
  def new_from_cross_channel
    press = PressLine.find(params[:id])
    language = Channel.find_by_name(params[:channel]).language
    if !(press.nil?) && !(language.nil?)
      @title = Title.find_by_english(press.original_title)
      if @title.nil? then
        @title = Title.new
        @title.english = press.original_title
        action = "new"
      else
        action = "edit"
      end
      set_local_title(press.display_title, language)  
      @title.source = params[:source] || "cross_channel"
      @title.channel = params[:channel] || ""
      @title.press_line_id = params[:id]|| nil
      render :action => action
    end  
  end

  def edit_from_manual_cross_channel
    language = Channel.find(params[:channel_id]).language
    if !(language.nil?)
      @title = Title.find(params[:id])
      if @title.nil? then
        @title = Title.new
        action = "new"
      else
        action = "edit"
      end
      @title.source = params[:source] || "cross_channel_manual"
      render :action => action
    end
  end


  def new_from_press
    @press = PressLine.find(params[:id])
    language = Channel.find_by_name(params[:channel]).language
    if !(@press.nil?) && !(language.nil?)
      title_all = Title.find_all_by_english(@press.original_title)
      session[:info] = {} if session[:info].nil?
      session[:info][:muvi2_action] = params[:muvi2_action]||""
      if title_all.size == 0 || params[:new_title]
        @title = Title.new
        @title.english = @press.original_title
        set_local_title(@press.display_title, language)  
        @title.source = params[:source]||"Press"
        @title.channel = params[:channel]||""
        @title.schedule_comparison_id = params[:schedule_comparison_id]
        @title.press_line_id = params[:id]
        @title.language = language
        render :action => 'new'
      elsif title_all.size == 1
        @title = title_all.first
        flash[:notice] = 'Title already in database. Editing details'
        session[:info] = {} if session[:info].nil?
        session[:info][:title_id] = @title.id
        session[:info][:press_id] = params[:id]
        session[:info][:search] = ""
        session[:info][:channel] = params[:channel]
        session[:info][:source] = params[:source]
        session[:info][:schedule_comparison_id] = params[:schedule_comparison_id]
        redirect_to edit_title_title_path
      else
        @titles = title_all
        session[:info] = {} if session[:info].nil?
        session[:info][:press_id] = params[:id]
        session[:info][:search] = ""
        session[:info][:channel] = params[:channel]
        session[:info][:source] = params[:source]
        session[:info][:schedule_comparison_id] = params[:schedule_comparison_id]
        render 'multiple_title'
      end
    end
  end

  def choose
    @title = Title.find(params[:id])
    if session[:info][:source] == 'cross_channel'
      redirect_to :controller => :cross_channel_priorities, :action => :xchannel_priority, 
  		 :id => session[:info][:press_id], :cross_tx_channel => session[:info][:channel], :title_id => @title 
    elsif session[:info][:muvi2_action] == 'auto_add_local_discrepancy_multiple'
      auto_add_with_local_discrepancy(session[:info][:press_id],session[:info][:language], session[:info][:schedule_comparison_id], session[:info][:source])
    else
      flash[:notice] = 'Title already in database. Editing details'
      session[:info][:title_id] = params[:id]
      redirect_to edit_title_title_path
    end
  end
  
  def auto_add_with_local_discrepancy(press_id, language, schedule_comparison_id, source)
    if update_press_titles(press_id, language)
      s = SeriesIdent.new
      s.update_info(@title.id, press_id)
      if s.save
        flash[:notice] = 'Series Ident was successfully created. '
        promo_added = s.add_missing_promos(@title.id)
        flash[:notice] += @template.pluralize(promo_added, 'Promo') + ' added. '
        stats = House.add_from_comparison(schedule_comparison_id, source)
        added = stats[:added]
        promo_added = stats[:promo_added]
        issues = stats[:issues]
        notice = stats[:notice]
        flash[:notice] += @template.pluralize(added, 'House Number') + ' added/updated. ' if added > 0
        flash[:notice] += @template.pluralize(issues,'Issue') + '. ' if issues > 0
        flash[:notice] += @template.pluralize(promo_added, 'Promo') + ' added. ' if promo_added > 0 
        flash[:notice] += notice
      else
        flash[:notice] = 'Issue saving series ident. '
        s.errors.each do |e|
          flash[:notice] += e.to_s.capitalize + ". "
        end
      end
      redirect_to schedule_comparison_path_with_filter_and_filename_with_recalculate
    end
  end
  
  def update_press_titles(press_id, language)
    stats = PressLine.update_press_titles(press_id, language, @title)
    flash[:notice] = stats[:notice]
    stats[:success]
  end
  
  def edit_title_house_or_series_known
    
    # Gets here from Comparison/Schedule Comparison
    # We know the house number or series _ident but there is a title discrepancy that will
    # be fixed in the edit title screen
    
    if params[:house_number]
      h = House.find_by_house_number(params[:house_number])
      @title = h.series_ident.title if h && h.series_ident
		end
    if @title.nil? && params[:eidr]
      s = SeriesIdent.find_by_eidr(params[:eidr])
      @title = s.title if s
    end
    if @title.nil? && params[:series_ident]
      s = SeriesIdent.find_by_number(params[:series_ident])
      @title = s.title if s
    end
    if @title
    	session[:info] = {} if session[:info].nil?
      session[:info][:title_id] = @title.id
      session[:info][:press_id] = params[:id]
      session[:info][:search] = ""
      session[:info][:channel] = params[:channel]
      session[:info][:source] = params[:source]
      session[:info][:schedule_comparison_id] = params[:schedule_comparison_id]
      redirect_to edit_title_title_path
    else
      flash[:notice] = "Cannot find title"
      redirect_to schedule_comparison_path_with_filter_and_filename
    end
  end
  
  def update_multiple_press_title
    # Gets here from edit title when user has pressed the link 
    # use title from titles database for all occurances in this schedule comparison file
    
    flash[:notice] = ''
    count = 0
    sc = ScheduleComparison.find(params[:schedule_comparison_id])
    press_original = PressLine.find_by_id(params[:id])
    logger.debug "THU26"
    logger.debug sc.schedule_file_id
    sc_lines = ScheduleComparison.find_all_by_schedule_file_id(sc.schedule_file_id)
    sc_lines.each do |sc_line|
    	press = PressLine.find_by_id(sc_line.press_id)
			if press
				logger.debug press.display_title
				if press.display_title == press_original.display_title || press.original_title == press_original.original_title
					logger.debug press.display_title
					logger.debug press.original_title
					if !params[:display].blank?
						existing_title = params[:display]
						clipsource_title = press.display_title
						notice = add_to_exception_list(params[:channel], params[:message], existing_title, clipsource_title, press.eidr, sc_line.house_number)
						if notice
							flash[:notice] += notice + ". "
						end
						press.display_title = params[:display]
					end
					if !params[:original].blank?
						existing_title = params[:original]
						clipsource_title = press.original_title
						notice = add_to_exception_list(params[:channel], params[:message], existing_title, clipsource_title, press.eidr, sc_line.house_number)
						if notice
							flash[:notice] += notice + ". "
						end
						press.original_title = params[:original]
					end
					if press.save
						count += 1
					else
						flash[:notice] += 'Issue with updating press title. '
					end
				end
			end
		end
		flash[:notice] += @template.pluralize(count, "Title") + " added"
		redirect_to edit_title_title_path
  end
  
  
  def update_press_title
    
    # Gets here from edit title when user has pressed the link 
    # use title from titles database.
    #ExceptionList.details(params[:channel], original, local)

    @press = PressLine.find_by_id(params[:id])
    if @press
    	if !params[:display].blank?
    		existing_title = params[:display]
    		clipsource_title = @press.display_title
    		sc = ScheduleComparison.find(params[:schedule_comparison_id])
    		notice = add_to_exception_list(params[:channel], params[:message], existing_title, clipsource_title, @press.eidr, sc.house_number)
				if notice
					flash[:notice]	= notice
				end			

    		@press.display_title = params[:display] unless params[:display].blank?
			end
			if !params[:original].blank?
    		existing_title = params[:original]
    		clipsource_title = @press.original_title 
    		sc = ScheduleComparison.find(params[:schedule_comparison_id])
    		notice = add_to_exception_list(params[:channel], params[:message], existing_title, clipsource_title, @press.eidr, sc.house_number)
    		if notice
					flash[:notice]	= notice
				end			
				@press.original_title = params[:original] unless params[:original].blank?
			end
      if !@press.save
      	if flash[:notice]
					flash[:notice] += '. Issue with updating press title'
				else
					flash[:notice] = 'Issue with updating press title'
				end
      end
    end
    redirect_to edit_title_title_path
  end
    
  def new_from_comparison
    @press = PressLine.find(params[:id])
    @promos = Promo.search(params[:search], params[:page])
    language = Channel.find_by_name(params[:channel]).language
    if !(@press.nil?) && !(language.nil?)
      @title = Title.find_by_english(@press.original_title)
      if @title.nil? 
        @title = Title.new
        @title.english = @press.original_title
        action = "new"
      else
        action = "edit"
        flash.now[:notice] = 'Title already in database. Editing details'
      end
      set_local_title(@press.display_title, language)  
      @title.source = params[:source]||"Press"
      @title.channel = params[:channel]||""
      @title.schedule_comparison_id = params[:schedule_comparison_id]
      @title.press_line_id = params[:id]
      @title.language = language
      render :action => action
    end
  end
  
  def create_series_ident
    s = SeriesIdent.new
    s.update_info(params[:title_id],params[:press_id])
    if s.save
      flash[:series_message] = 'Series Ident was successfully created. '
      if params[:with_promo]
        added = s.add_missing_promos(params[:title_id])
        flash[:series_message] += @template.pluralize(added, 'Promo') + ' added. '
      end
    else
      flash[:series_message] = ''
      s.errors.each do |e|
        flash[:series_message] += e.to_s.capitalize + ". "
      end
    end
    redirect_to edit_title_title_path
  end
  
  def delete_series_ident
    @series_ident = SeriesIdent.find(params[:id])
    @series_ident.destroy
    flash[:series_message] = 'Series Number Deleted'
    redirect_to edit_title_title_path
  end
  
  def change_series_ident
    s = SeriesIdent.find(params[:id])
    s.update_info(params[:title_id],params[:press_id])
    s.reset_legacy
    if s.save
      flash[:series_message] = 'Series Ident was successfully updated.'
    else
      flash[:series_message] = ''
      s.errors.each do |e|
        flash[:series_message] += e.to_s.capitalize + ". "
      end
    end
    redirect_to edit_title_title_path
  end

  def search_promo
    session[:info][:search] = params[:search]
    redirect_to edit_title_title_path
  end
  
  def add_promo
    @title = Title.find(params[:title_id])
    flash[:notice] = @title.add_promo(params[:promo_id])
    set_title_info
    redirect_to edit_title_title_path
  end
  
  def delete_promo
    s = SeriesIdent.find_by_id(params[:series_id])
    flash[:notice] = s.remove_promo(params[:promo_id]) if s
    redirect_to edit_title_title_path
  end
  
  def edit_title
    set_title_info
    render :action => 'edit'
  end
    
  # GET /titles/1/edit
  def edit
    @title = Title.find(params[:id])
    @title.source = 'Title'
    @promos = Promo.search(params[:search], params[:page])
  end
  
  
  # POST /titles
  # POST /titles.xml
  def create
    @title = Title.new(params[:title])
    respond_to do |format|
      if @title.save
        flash[:notice] = 'Title was successfully created.'
        if @title.source == "Press"
          new_series_ident
          format.html { redirect_to press_lines_with_date(session[:press_date], @title.channel) }
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        elsif @title.source == 'schedule_comparison'
        	logger.debug "XXXFRIDAY"
          new_series_ident
          ScheduleComparison.update_comparison_code(@title.schedule_comparison_id, @title.press_line_id)
          format.html { redirect_to schedule_comparison_path_with_filter_and_filename }
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        elsif @title.source == "Comparison" || @title.source == 'playlist_comparison'
          new_series_ident
          format.html { redirect_to comparison_path_with_filter_and_filename }
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        elsif @title.source == "cross_channel"
          new_series_ident
          format.html { redirect_to add_xchannel_priority(@title.press_line_id, @title.channel)}
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        elsif @title.source == "cross_channel_manual"
          format.html { redirect_to cross_channel_priorities_path }
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        else
          format.html { redirect_to titles_path_with_language }
          format.xml  { render :xml => @title, :status => :created, :location => @title }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /titles/1
  # PUT /titles/1.xml
  def update
    @title = Title.find(params[:id])
    respond_to do |format|
      if @title.update_attributes(params[:title])
        flash[:notice] = 'Title was successfully updated.'
        if @title.source == "Press"
          format.html { redirect_to press_lines_with_date(session[:press_date], @title.channel) }
          format.xml  { head :ok }
        elsif @title.source == "cross_channel"
          format.html {redirect_to add_xchannel_priority(@title.press_line_id, @title.channel)}
          format.xml  { head :ok }
        elsif @title.source == "cross_channel_manual"
          format.html { redirect_to cross_channel_priorities_path }
          format.xml  { head :ok }
        elsif @title.source == 'playlist_comparison'
          format.html { redirect_to comparison_path_with_filter_and_filename }
          format.xml  { head :ok }
        elsif @title.source == 'schedule_comparison'
          ScheduleComparison.update_comparison_code(@title.schedule_comparison_id, @title.press_line_id)
          format.html { redirect_to schedule_comparison_path_with_filter_and_filename }
          format.xml  { head :ok }  
        else
          format.html { redirect_to titles_path_with_language }
          format.xml  { head :ok }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /titles/1
  # DELETE /titles/1.xml
  def destroy
    @title = Title.find(params[:id])
    @title.destroy

    respond_to do |format|
      format.html { redirect_to titles_path_with_language_and_and_search_and_show_eidr(params[:search], params[:show_eidr]) }
      format.xml  { head :ok }
    end
  end
  
  def new_series
    @title = Title.find(params[:id])
    SeriesIdent.create_new_dummy(@title.id)
    redirect_to title_path{@title}
  end
  
  def clone
    @promos = Promo.search(params[:search], params[:page])
    t = Title.find_by_id(params[:id])
    if t
      @title = t.clone
      if @title.save
        s = SeriesIdent.find_by_id(params[:series_id])
        if s
          s.title_id = @title.id
          if s.save
            flash[:notice] = 'Title succesfully created'
          else
            flash[:notice] = 'Title succesfully created, but series ident issue'
          end
        else
          flash[:notice] = 'Title succesfully created, but series ident issue'
        end
        render :action => 'edit'
      else
        flash[:notice] = 'Issue with copy'
        @title = t
        render :action => 'edit'
      end  
    end
  end

  def auto_add_local_discrepancy_multiple
    @press = PressLine.find(params[:id])
    language = Channel.find_by_name(params[:channel]).language
    if !(@press.nil?) && !(language.nil?)
      @titles = Title.find_all_by_english(@press.original_title)
      session[:info] = {} if session[:info].nil?
      session[:info][:press_id] = params[:id]
      session[:info][:search] = ""
      session[:info][:channel] = params[:channel]
      session[:info][:language] = language.name
      session[:info][:source] = params[:source]
      session[:info][:schedule_comparison_id] = params[:schedule_comparison_id]
      session[:info][:muvi2_action] = params[:muvi2_action]

      render 'multiple_title'
    end
  end
  
  
  def auto_add_local_discrepancy
    press=PressLine.find(params[:id])
    @title = Title.find_by_english(press.original_title)
    language = Channel.find_by_name(params[:channel]).language
    auto_add_with_local_discrepancy(params[:id], language.name, params[:schedule_comparison_id], params[:source])
  end
  
  def stored_local
    press=PressLine.find(params[:id])
    @title = Title.find_by_english(press.original_title)
    language = Channel.find_by_name(params[:channel]).language
    stats = PressLine.update_press_title_with_stored(params[:id], language.name)
    flash[:notice] = stats[:notice]
    redirect_to schedule_comparison_path_with_filter_and_filename_with_recalculate
  end
  
###################################################################################################
private

  def set_local_title(local_title, language)

    case language.name
    when 'Danish'
      @title.danish = local_title
    when 'Swedish'
      @title.swedish = local_title
    when 'Hungarian'
      @title.hungarian = local_title
    when 'Norwegian'
      @title.norwegian = local_title
    end
  
  end  
  
  def index_html(params)

      @titles = Title.search(params[:search], params[:page])
      @languages = Language.display

      @danish = display_language("Danish")
      @swedish = display_language("Swedish")
      @norwegian = display_language("Norwegian")
      @hungarian = display_language("Hungarian")   
      @show_house = params[:house_no]     
      @show_series = params[:show_series]
      @show_eidr = params[:show_eidr]

  end
  
  def set_title_info
    @title = Title.find(session[:info][:title_id])
    @press = PressLine.find_by_id(session[:info][:press_id])
    if params[:search].blank?
      @promos = Promo.search(session[:info][:search], params[:page])
    else
      @promos = Promo.search(params[:search], params[:page])
    end
    @title.channel = session[:info][:channel]
    channel = Channel.find_by_name(session[:info][:channel])
    if !channel.nil?
      @title.language = channel.language.name||""
    else
      @title.language = ""
    end
    @elist = { :channel => session[:info][:channel], :original => @title.english, :local => @title.swedish}
    @title.source = session[:info][:source]
    @title.press_line_id = session[:info][:press_id]
    @title.schedule_comparison_id = session[:info][:schedule_comparison_id]
  end
  
  def new_series_ident
  	logger.debug @title.press_line_id
    if @title.press_line_id
      s=SeriesIdent.new
      s.update_info(@title.id, @title.press_line_id)
      if s.save
        flash[:notice] += ' Series Ident added.'
      end
    end
    if @title.series_idents.count == 0
      SeriesIdent.create_new_dummy(@title.id)
      flash[:notice] += ' Dummy Series Ident added.'
    end
  end
  
  def add_to_exception_list(channel, message, existing_title, clipsource_title, eidr, house_number)
		ex = ExceptionList.find_last_by_channel_name_and_message_and_existing_title_and_clipsource_title_and_eidr(channel, message, existing_title, clipsource_title, eidr)
		if ex
			do_it = ex.entry_time + 1.week < Time.now
		end
		if ex.nil? || do_it    		
			ex = ExceptionList.new
			ex.add_details(channel, existing_title, clipsource_title, eidr, house_number, message)
			if !ex.save
				'Issue with saving to exceptions list'
			else
				nil
			end
		end
	end  
    
end
