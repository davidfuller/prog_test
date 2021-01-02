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
    @channel_display = Channel.display

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
    @channel_display = Channel.display
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
    @channel_display = Channel.display

    respond_to do |format|
      format.html # cross_channel_selection.html.erb
      format.xml  #{ render :xml => @press_lines }
    end
  end
  
  
  
    
end
