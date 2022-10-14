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
    @press_lines = PressLine.schedule_lines(params[:show], params[:priority_date], params[:channel], params[:press_line_ids])     
    remove_v4 = true
    @channel_display = Channel.display(remove_v4)
    @filter_display = PressLine.schedule_filter
    @programmes = PressLine.programme_list(@press_lines)
    @parts = Part.parts_display
    params[:programme] = PressLine.selected_programme(@press_lines, params[:programme])
    logger.debug(params[:part])
    params[:part] = Part.selected_part(params[:part], params[:press_line_ids]!= params[:previous_press_line_ids])
    logger.debug("============++++++++++++++++=============")
    logger.debug(params[:part])
    logger.debug(params[:programme])
    @available = AutomatedDynamicSpecial.available_for_schedule(params)
    @templates = DynamicSpecialTemplate.template_display_with_all
    @message = PressLine.count_message(@press_lines)
  end

  def schedule_for_xml
    @press_lines = PressLine.schedule_lines_for_xml(params[:start_date], params[:channel], params[:days])
  end

  def random
    respond_to do |format|
      format.html { random_for_html }
    end
  end
  
  def add_random
    message = PressLine.randomly_schedule(params)
    logger.debug('Random generate message $$$$$$========')
    logger.debug message.join("\n")
    redirect_to special_random_with_date(params[:priority_date], params[:channel], params[:show], params[:template], params[:search], params[:part_ids], message.join("\n"))
  end

  def random_for_html
    @press_lines = PressLine.schedule_lines(params[:show], params[:priority_date], params[:channel], nil)     
    remove_v4 = true
    @channel_display = Channel.display(remove_v4)
    @filter_display = PressLine.schedule_filter
    @parts = Part.all_with_checked(params[:part_ids])
    @available = AutomatedDynamicSpecial.available_for_schedule(params)
    @templates = DynamicSpecialTemplate.template_display_with_all
    if params[:start_date].nil?
      params[:start_date] = params[:priority_date]
    end
    if params[:end_date].nil?
      params[:end_date] = params[:priority_date]
    end
    if params[:start_time].nil?
      params[:start_time] = '16:00'
    end
    if params[:end_time].nil?
      params[:end_time] = '23:59'
    end
    if params[:minimum_gap].nil?
      params[:minimum_gap] = '60'
    end
    @message = PressLine.random_generate_message(params)
    @result_message = params[:result_message]
    logger.debug "Mama-------"
    logger.debug @result_message
  end

  def add_special
    the_ids = params[:press_line_ids]
    count_added = 0
    count_updated = 0
    count_issues = 0
    if the_ids
      the_ids.each do |my_id|
        specials = PressLineAutomatedDynamicSpecialJoin.find_all_by_press_line_id_and_part_id(my_id, params[:part_id])
        if specials.length > 1
          for index in (specials.length-1).downto(1) do
            specials[index].destroy
          end
        end
        specials = PressLineAutomatedDynamicSpecialJoin.find_all_by_press_line_id_and_part_id(my_id, params[:part_id])
        if specials.length == 1
          special = specials[0]
          updated = true
        else
          special = PressLineAutomatedDynamicSpecialJoin.new
          updated = false
        end
        special.press_line_id = my_id
        special.automated_dynamic_special_id = params[:ads_id]
        special.part_id = params[:part_id]
        special.offset = -240
        special.tx_time = Part.special_tx_time_from_ids(my_id, params[:part_id])
        if special.save
          if updated
            count_updated += 1
          else
            count_added += 1
          end
        else
          count_issues += 1
        end
      end
    end
    flash[:notice] = count_message(count_added, count_updated, count_issues)
    params[:part_id] = Part.next(params[:part_id])
    respond_to do |format|
      format.html {redirect_to schedule_press_lines_path(:priority_date => params[:priority_date], :channel => params[:channel], :part => params[:part_id], :show => params[:show], :press_line_ids => params[:press_line_ids], :previous_press_line_ids => params[:press_line_ids])}
      format.xml  { render :xml => @press_lines }
    end
  end

  def count_message(count_added, count_updated, count_issues)
    if count_added == 0 && count_updated == 0 && count_issues == 0
      message = "Nothing updated or added and no issues"
    elsif count_added == 0 && count_updated == 0 && count_issues > 0
      message = "Nothing updated or added with " + count_issues.to_s + " issues"
    elsif count_added == 1 && count_updated == 0 && count_issues == 0
      message = "1 special added"
    elsif count_added > 1 && count_updated == 0 && count_issues == 0
      message = count_added.to_s + " specials added"
    elsif count_added == 0 && count_updated == 1 && count_issues == 0
      message = "1 special updated"
    elsif count_added == 0 && count_updated > 1 && count_issues == 0
      message = count_updated.to_s + " specials updated"
    elsif count_added == 1 && count_updated == 1 && count_issues == 0
      message = "1 special added and 1 updated"
    elsif count_added > 1 && count_updated == 1 && count_issues == 0
      message = count_added.to_s + " special added and 1 updated"
    elsif count_added == 1 && count_updated > 1 && count_issues == 0
      message = "1 special added and " + count_updated.ts_s + " updated"
    elsif count_added > 1 && count_updated > 1 && count_issues == 0
      message = count_added.to_s + " special added and " + count_updated.to_s + " updated"
    else
      message = count_added.to_s + " special added and " + count_updated.to_s + " updated and" + count_issues.to_s + " issues"  
    end
    message
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
