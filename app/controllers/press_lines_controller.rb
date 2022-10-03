class PressLinesController < ApplicationController
  # GET /press_lines
  # GET /press_lines.xml
  def index
    
    if params[:priority_date] then
      @press_lines = PressLine.priority_and_lead(params)
    else
      @press_lines = PressLine.search(params[:search], params[:press_date], params[:channel]) 
    end
    
    if params[:playlist_title]
      if flash.now[:notice].blank?
        flash.now[:notice] = params[:playlist_time] + ' - ' + params[:playlist_title]
      else
        flash.now[:notice] += ". " + params[:playlist_time] + ' - ' + params[:playlist_title]
      end
    end  
    remove_v4 = true
    @channel_display = Channel.display(remove_v4)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  #{ render :xml => @press_lines }
    end
  end

  # GET /press_lines/1
  # GET /press_lines/1.xml
  def show
    @press_line = PressLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @press_line }
    end
  end

  # GET /press_lines/new
  # GET /press_lines/new.xml
  def new
    @press_line = PressLine.new
    @channels = Channel.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @press_line }
    end
  end

  # GET /press_lines/1/edit
  def edit
    @press_line = PressLine.find(params[:id])
    @channels = Channel.all
  end

  # POST /press_lines
  # POST /press_lines.xml
  def create
    @press_line = PressLine.new(params[:press_line])

    respond_to do |format|
      if @press_line.save
        flash[:notice] = 'PressLine was successfully created.'
        format.html { redirect_to press_lines_path }
        format.xml  { render :xml => @press_line, :status => :created, :location => @press_line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @press_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /press_lines/1
  # PUT /press_lines/1.xml
  def update
    @press_line = PressLine.find(params[:id])

    respond_to do |format|
      if @press_line.update_attributes(params[:press_line])
        flash[:notice] = 'Successfully updated.'
        format.html { redirect_to press_lines_with_date(@press_line.start.to_s(:broadcast_date_full_month), 
                      @press_line.channel_name) }
        format.xml  { head :ok }
      else
        @channels = Channel.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @press_line.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def toggle_priority
    @press_line = PressLine.find(params[:id])
    @press_line.priority = !@press_line.priority
    respond_to do |format|
      if @press_line.save
    
        format.html { redirect_to press_lines_with_date(@press_line.start.to_s(:broadcast_date_full_month), 
                      @press_line.channel_name) }
        format.xml  { head :ok }
      else
        flash[:notice] = @press_line.errors
        format.html { redirect_to press_lines_with_date(nil,nil) }
        format.xml  { render :xml => @press_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  def toggle_audio
    @press_line = PressLine.find(params[:id])
    @press_line.audio_priority = !@press_line.audio_priority
    respond_to do |format|
      if @press_line.save
    
        format.html { redirect_to press_lines_with_date(@press_line.start.to_s(:broadcast_date_full_month), 
                      @press_line.channel_name) }
        format.xml  { head :ok }
      else
        flash[:notice] = @press_line.errors
        format.html { redirect_to press_lines_with_date(nil,nil) }
        format.xml  { render :xml => @press_line.errors, :status => :unprocessable_entity }
      end
    end
  end


  
  def toggle_priority_from_priority
    @press_line = PressLine.find(params[:id])
    @press_line.priority = !@press_line.priority
    respond_to do |format|
      if @press_line.save
        format.html { redirect_to priority_with_date(session[:priority_date], 
                      @press_line.channel_name, session[:priority_show]) }
        format.xml  { head :ok }
      else
        flash[:notice] = @press_line.errors
        format.html { redirect_to priority_with_date(nil, nil, nil) }
        format.xml  { render :xml => @press_line.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def toggle_audio_from_priority
    @press_line = PressLine.find(params[:id])
    @press_line.audio_priority = !@press_line.audio_priority
    respond_to do |format|
      if @press_line.save
        format.html { redirect_to priority_with_date(session[:priority_date], 
                      @press_line.channel_name, session[:priority_show]) }
        format.xml  { head :ok }
      else
        flash[:notice] = @press_line.errors
        format.html { redirect_to priority_with_date(nil, nil, nil) }
        format.xml  { render :xml => @press_line.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # DELETE /press_lines/1
  # DELETE /press_lines/1.xml
  def destroy
    @press_line = PressLine.find(params[:id])
    @press_line.destroy

    respond_to do |format|
      format.html { redirect_to(press_lines_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    PressLine.delete_all
    
    respond_to do |format|
      format.html { redirect_to(press_lines_url) }
      format.xml  { head :ok }
    end
    
  end

  def priority
    @press_lines = PressLine.priority_lines(params[:show], params[:priority_date], params[:channel])     
    remove_v4 = true
    @channel_display = Channel.display(remove_v4)
    @filter_display = Priority.filter_display

    respond_to do |format|
      format.html { render 'priority.html.erb'}
      format.xml  { render :xml => @press_lines }
    end
  end
  
  # GET /press_lines/cross_channel_selection

  def cross_channel_selection
    @cross_channel_priorities = CrossChannelPriority.search(params)
    @press_lines = PressLine.search(params[:search], params[:press_date], params[:channel]) 
    remove_v4 = true
    @channel_display = Channel.display(remove_v4)

    respond_to do |format|
      format.html # cross_channel_selection.html.erb
      format.xml  #{ render :xml => @press_lines }
    end
  end
  
  # GET /press_lines/schedule
  def schedule
    respond_to do |format|
      format.html { schedule_for_html }
      format.xml  { schedule_for_xml }
    end
  end

  def schedule_for_html
    @press_lines = PressLine.schedule_lines(params[:show], params[:priority_date], params[:channel])     
    remove_v4 = true
    @channel_display = Channel.display(remove_v4)
    @filter_display = PressLine.schedule_filter
    @programmes = PressLine.programme_list(@press_lines)
    @parts = Part.parts_display
    params[:programme] = PressLine.selected_programme(@press_lines, params[:programme])
    logger.debug("============++++++++++++++++=============")
    logger.debug (params[:programme])
    @available = AutomatedDynamicSpecial.available_for_schedule(params)
  end

  def schedule_for_xml
    @press_lines = PressLine.schedule_lines_for_xml(params[:start_date], params[:channel], params[:days])
  end

  def add_special
    specials = PressLineAutomatedDynamicSpecialJoin.find_all_by_press_line_id_and_part_id(params[:id], params[:part_id])
    if specials.length > 1
      for index in (specials.length-1).downto(1) do
        specials[index].destroy
      end
    end
    specials = PressLineAutomatedDynamicSpecialJoin.find_all_by_press_line_id_and_part_id(params[:id], params[:part_id])
    if specials.length == 1
      special = specials[0]
      notice = 'Special schedule updated'
    else
      special = PressLineAutomatedDynamicSpecialJoin.new
      notice = 'Special added to schedule'
    end
    special.press_line_id = params[:id]
    special.automated_dynamic_special_id = params[:ads_id]
    special.part_id = params[:part_id]
    special.offset = -240

    if special.save
      flash[:notice] = notice
    else
      flash[:notice] = "Issue with adding/updating special"
    end

    respond_to do |format|
      format.html {redirect_to schedule_press_lines_path(:priority_date => params[:priority_date], :channel => params[:channel], :programme => params[:id], :part => params[:part_id], :show => params[:show])}
      format.xml  { render :xml => @press_lines }
    end
  end
  
  def remove_special
    special = PressLineAutomatedDynamicSpecialJoin.find(params[:id])
    if special
      if special.destroy
        flash[:notice] = 'Special removed'
      else
        flash[:notice] = 'Unable to remove special'
      end
    else
      flash[:notice] = 'Cannot find special'
    end
    flash[:notice] = 'Special removed'
    respond_to do |format|
      format.html {redirect_to schedule_press_lines_path(:priority_date => params[:priority_date], :channel => params[:channel], :programme => params[:programme], :part => params[:part_id], :show => params[:show])}
      format.xml  { render :xml => @press_lines }
    end
  end
    
end
