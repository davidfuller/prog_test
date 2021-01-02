class CrossChannelPrioritiesController < ApplicationController
  # GET /cross_channel_priorities
  # GET /cross_channel_priorities.xml
  def index
    # @cross_channel_priorities = CrossChannelPriority.search(params)
    # @channel_display = Channel.display
    # 
    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.xml  { render :xml => @cross_channel_priorities }
    # end
    
    params[:cross_priority_date] ||= format_date_time(Date.today,"%B %e, %Y")
    params[:cross_tx_channel] ||= session[:cross_tx_channel] 
    params[:press_date] ||= format_date_time(Date.today,"%B %e, %Y")
		params[:channel] ||= session[:xchannel_press_channel]
		
    @cross_channel_priorities = CrossChannelPriority.search(params)
    @press_lines = PressLine.search(params[:search], params[:press_date], params[:channel]) 
    @tx_channel_display = Channel.display
    @press_channel_display = Channel.display

    respond_to do |format|
      format.html #
      format.xml  #{ render :xml => @cross_channel_priorities }
    end
  end


  # GET /cross_channel_priorities/1
  # GET /cross_channel_priorities/1.xml
  def show
    @cross_channel_priority = CrossChannelPriority.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cross_channel_priority }
    end
  end

  # GET /cross_channel_priorities/new
  # GET /cross_channel_priorities/new.xml
  def new
    @cross_channel_priority = CrossChannelPriority.new
    if params[:cross_tx_channel]
      @cross_channel_priority.tx_channel_id = Channel.find_by_name(params[:cross_tx_channel]).id
    end
    if params[:cross_priority_date]
      @cross_channel_priority.cross_priority_date = params[:cross_priority_date]
    end
    
    @channels = Channel.all
    @titles = Title.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cross_channel_priority }
    end
  end

  # GET /cross_channel_priorities/1/edit
  def edit
    @cross_channel_priority = CrossChannelPriority.find(params[:id])
    @channels = Channel.all
    @titles = Title.all
    if params[:cross_priority_date]
      @cross_channel_priority.cross_priority_date = params[:cross_priority_date]
    end
  end

  # POST /cross_channel_priorities
  # POST /cross_channel_priorities.xml
  def create
    @cross_channel_priority = CrossChannelPriority.new(params[:cross_channel_priority])

    respond_to do |format|
      if @cross_channel_priority.save
        flash[:notice] = 'Cross Channel Priority was successfully created.'
        format.html { redirect_to(cross_channel_priorities_path(:cross_tx_channel => @cross_channel_priority.tx_channel_display)) }
        format.xml  { render :xml => @cross_channel_priority, :status => :created, :location => @cross_channel_priority }
      else
        @channels = Channel.all
        @titles = Title.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @cross_channel_priority.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cross_channel_priorities/1
  # PUT /cross_channel_priorities/1.xml
  def update
    @cross_channel_priority = CrossChannelPriority.find(params[:id])

    respond_to do |format|
      if @cross_channel_priority.update_attributes(params[:cross_channel_priority])
        format.html do
          if fix_local_title?(params[:cross_channel_priority])
            redirect_to edit_title_from_manual_cross_channel(params[:cross_channel_priority][:title_id], params[:cross_channel_priority][:channel_id])
          else
            flash[:notice] = 'Cross Channel Priority was successfully updated.'            
            redirect_to(cross_channel_priorities_with_date(session[:xchannel_press_date],
            session[:cross_priority_date])) 
          end
        end
        format.xml  { head :ok }
      else
        @channels = Channel.all
        @titles = Title.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cross_channel_priority.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cross_channel_priorities/1
  # DELETE /cross_channel_priorities/1.xml
  def destroy
    @cross_channel_priority = CrossChannelPriority.find(params[:id])
    @cross_channel_priority.destroy

    respond_to do |format|
      format.html { redirect_to(cross_channel_priorities_with_date(session[:xchannel_press_date],
                      session[:cross_priority_date])) }
      format.xml  { head :ok }
    end
  end
  
  def press_lines_from_cross_channel_priority(priority)
    date = priority.billed_display_for_press_lines
    channel_name = priority.channel_display
    tx_channel_name = priority.tx_channel_display
    
    {:controller => :press_lines, :action => :cross_channel_selection, :search => '', :press_date => date, 
        :channel => channel_name, :cross_tx_channel => tx_channel_name, :cross_id => priority,
        :cross_priority_date => priority.cross_priority_date}
  end

  def xchannel_priority
    press_line = PressLine.find(params[:id])
    tx_channel = Channel.find_by_name(params[:cross_tx_channel])
    language = tx_channel.language.name||""
    if params[:title_id]
      titles = Title.find_all_by_id(params[:title_id])
    elsif press_line.eidr
    	titles = Title.find_eidr(press_line.eidr)
    end
    if !titles
      titles = Title.find_all_by_english(press_line.original_title)
    end
    if titles.size == 0
      flash[:notice] = "The Title does not have an entry in any language. " +
                       "It has been added from the Press Listing entry. Please check and update"
  		redirect_to new_from_press_title_path(press_line, :source => 'cross_channel', :channel => params[:cross_tx_channel])
		elsif titles.size ==1
      title = titles.first
      if title.has_language?(language)
        x_channel_priority = CrossChannelPriority.new
        x_channel_priority.title = title
        x_channel_priority.billed = press_line.start
        x_channel_priority.lead_text = press_line.lead_text
        x_channel_priority.channel = press_line.channel
        x_channel_priority.tx_channel_id = tx_channel.id
        x_channel_priority.series_ident = press_line.series_number
        x_channel_priority.eidr = press_line.eidr
        x_channel_priority.save
        flash[:notice] = "The priority has been added"
        @cross_channel_priorities = CrossChannelPriority.search(params)
        redirect_to cross_channel_priorities_with_date(session[:xchannel_press_date], session[:cross_priority_date])
      else
        flash[:notice] = "Title does not have entry in " + language + ". " +
                        "It has been added from the Press Listing entry. Please check and update"
    		redirect_to new_from_press_title_path(press_line, :source => 'cross_channel', :channel => params[:cross_tx_channel]) 
      end
    else
      flash[:notice] = "Title has multiple entries. Please choose."
  		redirect_to new_from_press_title_path(press_line, :source => 'cross_channel', :channel => params[:cross_tx_channel])
    end
  end
  
  def fix_local_title?(params)
    title = Title.find(params[:title_id])
    tx_channel = Channel.find(params[:channel_id])
    language = tx_channel.language.name||""
    if title.has_language?(language)
      return false
    else
      flash[:notice] =  "Title does not have entry in " + language + ". " +
                        "Please enter"
      return true
    end     
  end
  
end



