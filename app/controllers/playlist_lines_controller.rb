class PlaylistLinesController < ApplicationController
  # GET /playlist_lines
  # GET /playlist_lines.xml
  
  def index
    
    @filters = PlaylistLine::FILTERS
    @filter_display = PlaylistLine.filter_display
    @filenames = PlaylistFilename.display
    @selected_file = params[:filename]||PlaylistFilename.last.id
    
    logger.debug "selected_file=> " + @selected_file.to_s
    
    if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
      @playlist_lines = PlaylistLine.search_by_filename_id(params, @selected_file)
    else
      params[:show] = 'full_progs_part1'
      if not params[:filename]
        params[:filename] = PlaylistFilename.last.id.to_s
      end
      @playlist_lines = PlaylistLine.search_by_filename_id(params, @selected_file)
    end
    if @playlist_lines.first.nil?
      @heading_date = nil
    else
      @heading_date = @playlist_lines.first.start  
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @playlist_lines }
    end
  end

    
  # GET /playlist_lines/1
  # GET /playlist_lines/1.xml
  def show
    @playlist_line = PlaylistLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @playlist_line }
    end
  end

  # GET /playlist_lines/new
  # GET /playlist_lines/new.xml
  def new
    @playlist_line = PlaylistLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @playlist_line }
    end
  end

  # GET /playlist_lines/1/edit
  def edit
    @playlist_line = PlaylistLine.find(params[:id])
  end

  # POST /playlist_lines
  # POST /playlist_lines.xml
  def create
    @playlist_line = PlaylistLine.new(params[:playlist_line])

    respond_to do |format|
      if @playlist_line.save
        flash[:notice] = 'PlaylistLine was successfully created.'
        format.html { redirect_to(@playlist_line) }
        format.xml  { render :xml => @playlist_line, :status => :created, :location => @playlist_line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @playlist_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /playlist_lines/1
  # PUT /playlist_lines/1.xml
  def update
    @playlist_line = PlaylistLine.find(params[:id])

    respond_to do |format|
      if @playlist_line.update_attributes(params[:playlist_line])
        flash[:notice] = 'PlaylistLine was successfully updated.'
        format.html { redirect_to(@playlist_line) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @playlist_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /playlist_lines/1
  # DELETE /playlist_lines/1.xml
  def destroy
    @playlist_line = PlaylistLine.find(params[:id])
    @playlist_line.destroy

    respond_to do |format|
      format.html { redirect_to(playlist_lines_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_all
    PlaylistLine.delete_all
    
    respond_to do |format|
      format.html { redirect_to(playlist_lines_url) }
      format.xml  { head :ok }
    end
    
  end
    
end
