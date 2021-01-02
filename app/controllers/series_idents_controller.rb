class SeriesIdentsController < ApplicationController
  
  before_filter :authenticate, :only => [:destroy_all, :add_dummy]
  
  # GET /series_idents
  # GET /series_idents.xml
  def index
   
    respond_to do |format|
      format.html { @series_idents = SeriesIdent.search(params) }
      format.xml {  @series_idents = SeriesIdent.all }
      format.html # index.html.erb
      format.xml  { render :xml => @series_idents }
    end
  end

  # GET /series_idents/1
  # GET /series_idents/1.xml
  def show
    @series_ident = SeriesIdent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @series_ident }
    end
  end

  # GET /series_idents/new
  # GET /series_idents/new.xml
  def new
    @series_ident = SeriesIdent.new
    @titles = Title.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @series_ident }
    end
  end

  # GET /series_idents/1/edit
  def edit
    @series_ident = SeriesIdent.find(params[:id])
    @titles = Title.all
  end

  def edit_from_title
    @series_ident = SeriesIdent.find(params[:id])
    @series_ident.source = params[:source]
    @series_ident.original_id = params[:original_params][:id]
    @series_ident.original_channel = params[:original_params][:channel]
    @titles = Title.all
    render :action => "edit"
  end
  
  def edit_from_comparison
    # We get here from comparisons when the years do not match
    if params[:eidr]
    	s = SeriesIdent.find_by_eidr(params[:eidr])
		end
    if s.nil? && params[:series_ident]
    	s = SeriesIdent.find_by_number(params[:series_ident])
    end
    if s
      session[:series_info] = {} if session[:series_info].nil?
      session[:series_info][:series_id] = s.id
      session[:series_info][:press_id] = params[:id]
      session[:series_info][:source] = params[:source]
      session[:series_info][:schedule_comparison_id] = params[:schedule_comparison_id]
      redirect_to edit_series_series_ident_path
    else
    	flash[:notice] = 'Cannot find series'
    	redirect_to schedule_comparison_path_with_filter_and_filename
    end
  end
  
  def edit_series
    set_series_info
    render :action => 'edit'
  end
  
  
  def update_press_series
    # Gets here from edit series ident when user has pressed the link 
    # use existing year from database.
    
    @press = PressLine.find_by_id(params[:id])
    if @press
      @press.year_number = params[:year]
      if !@press.save
        flash[:notice] = 'Issue with updating press title'
      end
    end
    redirect_to edit_series_series_ident_path
  end

  # POST /series_idents
  # POST /series_idents.xml
  def create
    @series_ident = SeriesIdent.new(params[:series_ident])

    respond_to do |format|
      if @series_ident.save
        flash[:notice] = 'Series Ident was successfully created.'
        format.html { redirect_to(series_idents_url) }
        format.xml  { render :xml => @series_ident, :status => :created, :location => @series_ident }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @series_ident.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /series_idents/1
  # PUT /series_idents/1.xml
  def update
    @series_ident = SeriesIdent.find(params[:id])

    respond_to do |format|
      if @series_ident.update_attributes(params[:series_ident])
        flash[:notice] = 'Series Ident was successfully updated.'
        format.html {
          if @series_ident.source == 'Press'
            redirect_to :controller => 'titles', :action => 'new_from_press', 
        							:id => @series_ident.original_id, :source => @series_ident.source, 
        							:channel => @series_ident.original_channel
      		elsif @series_ident.source == 'Title'
      		  redirect_to edit_title_path(@series_ident.title_id)
    		  elsif @series_ident.source ==  'playlist_comparison'
              redirect_to comparison_path_with_filter_and_filename
          elsif @series_ident.source ==  'schedule_comparison'
            ScheduleComparison.update_comparison_code(@series_ident.schedule_comparison_id, @series_ident.press_id)
            redirect_to schedule_comparison_path_with_filter_and_filename
        	else
            redirect_to(series_idents_url)
          end 
        }
        format.xml  { head :ok }
      else
        @titles = Title.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @series_ident.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /series_idents/1
  # DELETE /series_idents/1.xml
  def destroy
    @series_ident = SeriesIdent.find(params[:id])
    @series_ident.destroy

    respond_to do |format|
      format.html { redirect_to(series_idents_url) }
      format.xml  { head :ok }
    end
  end
  
  def destroy_all
    SeriesIdent.destroy_all
    session[:logout_requested] = true

    respond_to do |format|
      format.html { redirect_to(series_idents_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_dummy
    Title.add_dummy
    session[:logout_requested] = true

    respond_to do |format|
      format.html { redirect_to(series_idents_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def set_series_info
    @series_ident = SeriesIdent.find(session[:series_info][:series_id])
    @press = PressLine.find_by_id(session[:series_info][:press_id])
    @series_ident.source = session[:series_info][:source]
    @series_ident.schedule_comparison_id = session[:series_info][:schedule_comparison_id]
    @series_ident.press_id = session[:series_info][:press_id]
    @titles = Title.all
  end
    
end
