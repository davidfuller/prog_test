class ScheduleComparisonsController < ApplicationController
  # GET /schedule_comparisons
  # GET /schedule_comparisons.xml
  def index
    
  #  if params[:schedule_filename] != session[:schedule_comparison_filename] || params[:commit] == "Recalculate"
  #    calc(params[:schedule_filename])
  #  end
    
    if params[:commit] == "Recalculate"
      calc(params[:schedule_filename])
    end


    @filter_display = ScheduleComparison.filtered_filter_display(params[:schedule_filename])
    @colour_display = ScheduleComparison.filtered_colour_display(params[:schedule_filename])
    @filters = ScheduleComparison::FILTERS
    @filenames = ScheduleFile.display
    @file = ScheduleFile.find_by_id(params[:schedule_filename])

    if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
      @schedule_comparisons = ScheduleComparison.send(params[:show]).find_all_by_schedule_file_id(params[:schedule_filename])
      if @schedule_comparisons.size == 0
        @schedule_comparisons = ScheduleComparison.send('all').find_all_by_schedule_file_id(params[:schedule_filename])
        if @schedule_comparisons.size == 0
          calc(params[:schedule_filename])
          @schedule_comparisons = ScheduleComparison.send('all').find_all_by_schedule_file_id(params[:schedule_filename])
        end
      end
    else
      @schedule_comparisons = ScheduleComparison.send('all').find_all_by_schedule_file_id(params[:schedule_filename])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedule_comparisons }
    end
  end

  # GET /schedule_comparisons/1
  # GET /schedule_comparisons/1.xml
  def show
    @schedule_comparison = ScheduleComparison.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule_comparison }
    end
  end

  # GET /schedule_comparisons/new
  # GET /schedule_comparisons/new.xml
  def new
    @schedule_comparison = ScheduleComparison.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @schedule_comparison }
    end
  end

  # GET /schedule_comparisons/1/edit
  def edit
    @schedule_comparison = ScheduleComparison.find(params[:id])
  end

  # POST /schedule_comparisons
  # POST /schedule_comparisons.xml
  def create
    @schedule_comparison = ScheduleComparison.new(params[:schedule_comparison])

    respond_to do |format|
      if @schedule_comparison.save
        flash[:notice] = 'ScheduleComparison was successfully created.'
        format.html { redirect_to(@schedule_comparison) }
        format.xml  { render :xml => @schedule_comparison, :status => :created, :location => @schedule_comparison }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @schedule_comparison.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schedule_comparisons/1
  # PUT /schedule_comparisons/1.xml
  def update
    @schedule_comparison = ScheduleComparison.find(params[:id])

    respond_to do |format|
      if @schedule_comparison.update_attributes(params[:schedule_comparison])
        flash[:notice] = 'ScheduleComparison was successfully updated.'
        format.html { redirect_to(@schedule_comparison) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @schedule_comparison.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schedule_comparisons/1
  # DELETE /schedule_comparisons/1.xml
  def destroy
    @schedule_comparison = ScheduleComparison.find(params[:id])
    @schedule_comparison.destroy

    respond_to do |format|
      format.html { redirect_to(schedule_comparisons_url) }
      format.xml  { head :ok }
    end
  end
  
  def calc(filename_id)
    ScheduleComparison.delete_all("schedule_file_id = " + filename_id)
    ScheduleLine.find_all_by_schedule_file_id(filename_id).each do |p|
      press = PressLine.find_by_start_and_channel(p.start, p.schedule_file.channel)
      ScheduleComparison.add_prog(p, press)
    end
  end
  
  def add
    stats = Title.add_from_schedule_comparison(ScheduleComparison.find(params[:id]))
    ScheduleComparison.update_conditions(params[:id])
    success = stats[:success]
    added = stats[:added]
    house_added = stats[:house_added]
    issues = stats[:issues]
    house_issues = stats[:house_issues]
    notice = stats[:notice]
    flash[:notice] = ""
    flash[:notice] += @template.pluralize(added, 'Title') + ' added. ' if added > 0
    flash[:notice] += @template.pluralize(house_added, 'House Number') + ' added. ' if house_added > 0 
    flash[:notice] += @template.pluralize(issues, 'Title issue') + '. ' if issues > 0
    flash[:notice] += @template.pluralize(house_issues, 'House Number issue') + '. ' if house_issues > 0
    flash[:notice] += notice
    redirect_to(schedule_comparison_path_with_filter_and_filename)
  end
  
  def add_multiple
    success = true
    if params[:schedule_comparison_ids] != nil
      flash[:notice] = ""
      notice=""
      added = 0
      house_added = 0
      issues = 0
      house_issues = 0
      params[:schedule_comparison_ids].each do |id| 
        stats = Title.add_from_schedule_comparison(ScheduleComparison.find(id))
        ScheduleComparison.update_conditions(id)
        added += stats[:added]
        house_added += stats[:house_added]
        issues += stats[:issues]
        house_issues += stats[:house_issues]
        notice += stats[:notice]
      end
        flash[:notice] += @template.pluralize(added, 'Title') + ' added. ' if added > 0
        flash[:notice] += @template.pluralize(house_added, 'House Number') + ' added. ' if house_added > 0 
        
        flash[:notice] += @template.pluralize(issues, 'Title issue') + '. ' if issues > 0
        flash[:notice] += @template.pluralize(house_issues, 'House Number issue') + '. ' if house_issues > 0
        flash[:notice] += notice
    else
      flash[:notice] = "Nothing checked"
    end
    redirect_to(schedule_comparison_path_with_filter_and_filename)
  end
  
  def keep_series
    # We get here if the user has decided that series number in the db is correct and 
    # the one in the press listing is wrong.To make this work we change the the series number in the
    # press listing to the one stored in the database
    
    h = House.find_by_house_number(params[:house_number])
    p = PressLine.find_by_id(params[:press_id])
    if p && h.series_ident.number
      p.series_number = h.series_ident.number
      if p.save
        flash[:notice] = "Press Listing updated"
      else
        flash[:notice] = "Problem updating the press listing"
      end
    else
      flash[:notice] = "Problem updating the press listing"
    end
    
    if params[:source] == 'schedule_comparison'
      ScheduleComparison.update_comparison_code(params[:id], params[:press_id])
      redirect_to schedule_comparison_path_with_filter_and_filename
    else
      redirect_to comparison_path_with_filter_and_filename
    end
  end
  
  def delete_house
    House.find_by_house_number(params[:house_number]).destroy
    flash[:notice] = "House number unlinked"        
    if params[:source] == 'schedule_comparison'
      redirect_to schedule_comparison_path_with_filter_and_filename_with_recalculate     
    end
  end
  
  def add_eidr
  	series_ident = SeriesIdent.find_by_number(params[:series_ident])
  	series_ident.add_eidr(params[:press_id])
  	if series_ident.save
			if params[:source] == 'schedule_comparison'
				ScheduleComparison.update_comparison_code(params[:id], params[:press_id])
				redirect_to schedule_comparison_path_with_filter_and_filename
			end
		end
  end
  
end
