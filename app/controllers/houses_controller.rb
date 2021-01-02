class HousesController < ApplicationController
  
  before_filter :authenticate, :only => :add_all_series_ident

  # GET /houses
  # GET /houses.xml
  def index
  
    respond_to do |format|
      format.html { @houses = House.search(params[:search], params[:page]) }
      format.xml { @houses = House.all }
    end
  end

  # GET /houses/1
  # GET /houses/1.xml
  def show
    @house = House.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @house }
    end
  end

  # GET /houses/new
  # GET /houses/new.xml
  def new
    @house = House.new
    @titles = Title.search(params[:search], params[:page])
    @house.source = params[:source]||'new'
    @house.comparison_id = params[:comparison_id]
    @house.house_number = params[:house_number]
    @house.schedule_comparison_id = params[:schedule_comparison_id]
    @house.press_id = params[:press_id]
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @house }
    end
  end
  
  def new_from_comparison
    @titles = Title.search(params[:search], params[:page])
    if params[:source] == 'schedule_comparison'
      comp = ScheduleComparison.find_by_id(params[:id])
    else
      comp = Comparison.find(params[:id])
    end
    if not comp.nil?
      @house = House.find_by_house_number(comp.house_number)
      if @house.nil? then
        flash[:notice] = comp.title
        redirect_to new_house_path(:source => params[:source], :house_number => comp.house_number, 
                                    :schedule_comparison_id => params[:id],
                                    :press_id => params[:press_id])
      else
        flash[:notice] = comp.title + '. House number already in database. You can edit details if you wish'
        redirect_to edit_house_path(:id => @house.id, :source => params[:source], 
                                    :schedule_comparison_id => params[:id],
                                    :press_id => params[:press_id])
      end
    end
  end
  
  def new_from_schedule_comparison
    @titles = Title.all
    @series_numbers = SeriesNumber.all
    comp = ScheduleComparison.find(params[:id])
    if not comp.nil?
      @house = House.find_by_house_number(comp.house_number)
      if @house.nil? then
        flash[:notice] = comp.title
        @house = House.new
        @house.house_number = comp.house_number
        s = SeriesNumber.find_or_create_by_series_number(comp.series_number)
        if s
          @house.series_number = s
        end if
        @house.source = 'schedule comparison'
        @house.schedule_comparison = comp.id
        render :action => "new"
      else
        flash[:notice] = 'House number already in database. You can edit details if you wish'
        @house.source = 'schedule comparison'
        render :action => "edit"
      end
    end  
  end
  
    
  # GET /houses/1/edit
  def edit
    @house = House.find(params[:id])
    @house.source = params[:source]||'edit'
    @house.schedule_comparison_id = params[:schedule_comparison_id]
    @house.press_id = params[:press_id]
    @titles = Title.search(params[:search]||@house.english_title, params[:page])
  end

  # POST /houses
  # POST /houses.xml
  def create
    @house = House.new(params[:house])

    respond_to do |format|
      if @house.save
        flash[:notice] = 'House number was successfully created. '
        format.html { 
          if @house.source == 'comparison'
            redirect_to comparison_path_with_filter_and_filename
          elsif @house.source == 'schedule_comparison'
            ScheduleComparison.update_comparison_code(@house.schedule_comparison_id, @house.press_id)
            redirect_to schedule_comparison_path_with_filter_and_filename
          else  
            redirect_to houses_path
          end
          }
        format.xml  { render :xml => @house, :status => :created, :location => @house }
      else
        @titles = Title.search(params[:search]||@house.english_title, params[:page])
        format.html { render :action => "new" }
        format.xml  { render :xml => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /houses/1
  # PUT /houses/1.xml
  def update
    @house = House.find(params[:id])
    respond_to do |format|
      if @house.update_attributes(params[:house])
        flash[:notice] = 'House number was successfully updated.'
        if @house.source == 'comparison'
          format.html { redirect_to comparison_path_with_filter_and_filename }
        elsif @house.source == 'schedule_comparison'
          ScheduleComparison.update_comparison_code(@house.schedule_comparison_id, @house.press_id)
          format.html { redirect_to schedule_comparison_path_with_filter_and_filename }
        else
          format.html { redirect_to houses_path }
          format.xml  { head :ok }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /houses/1
  # DELETE /houses/1.xml
  def destroy
    @house = House.find(params[:id])
    @house.destroy

    respond_to do |format|
      format.html { redirect_to(houses_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_all_series_ident
    num = 0
    hse = House.all
    hse.each do |h|
      if h.title
        if h.title.series_idents.count > 0
          h.series_ident_id = h.title.series_idents[0].id
          if h.save
            num += 1
          end
        end
      end
    end
    flash[:notice] = num.to_s + " House numbers updated with Series Idents"
    session[:logout_requested] = true
    redirect_to houses_path
  end
  
end
