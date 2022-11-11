class ComparisonsController < ApplicationController

  include ComparisonsHelper

  def calculate
    calc
    redirect_to(comparison_path_with_filter_and_filename)
  end
  
  def add
    stats = Title.add_from_playlist_comparison(Comparison.find(params[:id]))
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
    redirect_to(comparison_path_with_filter_and_filename)
  end
  
  def add_series
    stats = House.add_from_comparison(params[:id], params[:source])
    added = stats[:added]
    promo_added = stats[:promo_added]
    issues = stats[:issues]
    notice = stats[:notice]
    flash[:notice] = ""
    flash[:notice] += @template.pluralize(added, 'House Number') + ' added/updated. ' if added > 0
    flash[:notice] += @template.pluralize(issues,'Issue') + '. ' if issues > 0
    flash[:notice] += @template.pluralize(promo_added, 'Promo') + ' added. ' if promo_added > 0 
    flash[:notice] += notice
    if params[:source] == 'schedule_comparison'
      ScheduleComparison.update_comparison_code(params[:id], params[:press_id])
      redirect_to schedule_comparison_path_with_filter_and_filename
    else
      redirect_to comparison_path_with_filter_and_filename
    end
  end
  
  
  def add_title_series
    stats = Title.add_series_and_house(params[:id], params[:source], params[:eop])
    added = stats[:added]
    title_added = stats[:title_added]
    local_added = stats[:local_added]
    house_added = stats[:house_added]
    promo_added = stats[:promo_added]
    issues = stats[:issues]
    title_issues = stats[:title_issues]
    local_issues = stats[:local_issues]
    house_issues = stats[:house_issues]
    notice = stats[:notice]
    flash[:notice] = ""
    flash[:notice] += @template.pluralize(title_added, 'Original title') + ' added. ' if title_added > 0
    flash[:notice] += @template.pluralize(local_added, 'Local title') + ' added. ' if local_added > 0
    flash[:notice] += @template.pluralize(added, 'Series number') + ' added. ' if added > 0
    flash[:notice] += @template.pluralize(house_added, 'House Number') + ' added. ' if house_added > 0 
    flash[:notice] += @template.pluralize(promo_added, 'Promo') + ' added. ' if promo_added > 0 
    flash[:notice] += @template.pluralize(title_issues, 'original title issue') + '. ' if title_issues > 0
    flash[:notice] += @template.pluralize(local_issues, 'local title issue') + '. ' if local_issues > 0
    flash[:notice] += @template.pluralize(issues, 'Series number issue') + '. ' if issues > 0
    flash[:notice] += @template.pluralize(house_issues, 'House Number issue') + '. ' if house_issues > 0
    flash[:notice] += notice
    if params[:source] == 'schedule_comparison'
      ScheduleComparison.update_comparison_code(params[:id], params[:press_id])
      redirect_to schedule_comparison_path_with_filter_and_filename_with_recalculate
    else
      redirect_to(comparison_path_with_filter_and_filename)
    end
  end
  
  def add_eidr_to_house
  	stats =	House.add_eidr_to_existing_house(params[:id], params[:source])
		issues = stats[:issues]
    notice = stats[:notice]
    added = stats[:added]
    flash[:notice] = ""
    flash[:notice] += @template.pluralize(added, 'House Number') + ' added/updated. ' if added > 0
    flash[:notice] += @template.pluralize(issues,'Issue') + '. ' if issues > 0
    flash[:notice] += notice
		if params[:source] == 'schedule_comparison'
      ScheduleComparison.update_comparison_code(params[:id], params[:press_id])
      redirect_to schedule_comparison_path_with_filter_and_filename
    else
      redirect_to comparison_path_with_filter_and_filename
    end
	end
  
  def add_local_title
    stats = Title.add_local_title(params[:id], params[:source])
    added = stats[:added]
    issues = stats[:issues]
    notice = stats[:notice]
    flash[:notice] = ""
    flash[:notice] += @template.pluralize(added, 'Local title') + ' added. ' if added > 0
    flash[:notice] += @template.pluralize(issues, 'Local title issue') + '. ' if issues > 0
    flash[:notice] += notice
    if params[:source] == 'schedule_comparison'
      ScheduleComparison.update_comparison_code(params[:id], params[:press_id])
      redirect_to schedule_comparison_path_with_filter_and_filename
    else
      redirect_to comparison_path_with_filter_and_filename
    end
  end
    
  def add_multiple
    if params[:comparison_ids] != nil
      flash[:notice] = ""
      notice=""
      added = 0
      created = 0
      title_added = 0
      local_added = 0
      house_added = 0
      promo_added = 0
      eidr_added = 0
      issues = 0
      title_issues = 0
      local_issues = 0
      house_issues = 0
      local_fix_added = 0
      local_fix_issues = 0
      created_issues = 0
      params[:comparison_ids].each do |id|
        if params[:source] == 'schedule_comparison'
          c = ScheduleComparison.find_by_id(id)
        else
          c = Comparison.find_by_id(id)
        end
        if params[:commit] == add_all_checked_sports_button 
          title = c.original_title||""
          eidr = c.eidr||""
          if is_sport?(eidr)
            stats = Title.new_title_from_multiple(c)
            created += stats[:created]
            created_issues += stats[:issues]
            title_issues += stats[:title_issues]
            house_issues += stats[:house_issues]
            notice += stats[:notice]
          else
            notice += "Cannot process: #{title} as the eidr is not sport. "
          end
        else
          case c.comparison_code.to_sym
          when :not_db_all_match
            stats = House.add_from_comparison(id, params[:source])
            house_added += stats[:added]
            house_issues += stats[:issues]
            notice += stats[:notice]
          when *[:not_db_no_series, :not_db_no_match_contained, :not_db_no_match, :not_db_no_series_local_blank]
            stats = Title.add_series_and_house(id, params[:source], nil)
            added = stats[:added]
            title_added += stats[:title_added]
            local_added += stats[:local_added]
            house_added += stats[:house_added]
            promo_added += stats[:promo_added]
            issues += stats[:issues]
            title_issues += stats[:title_issues]
            local_issues += stats[:local_issues]
            house_issues += stats[:house_issues]
            notice = stats[:notice]
          when *[:in_db_local_blank, :not_db_local_blank]
            stats = Title.add_local_title_and_house(c)
            local_added += stats[:added]
            local_issues += stats[:issues]
            notice = stats[:notice]
          when *[:not_db_fix_local, :in_db_fix_local]
            language = Channel.find(c.channel_id).language
            stats = PressLine.update_press_title_with_stored(c.press_id, language.name)
            local_fix_added += stats[:added]
            local_fix_issues += stats[:issues]
          when :in_db_no_eidr
            series_ident = SeriesIdent.find_by_number(c.series_ident)
            series_ident.add_eidr(c.press_id)
            if series_ident.save
              eidr_added += 1
            end
          when :in_db_fix_series
            stats =	House.add_eidr_to_existing_house(id, params[:source])
            house_issues = stats[:issues]
            notice += stats[:notice]
            house_added = stats[:added]
          else
            title = c.original_title||""
            notice += 'Cannot process title ' + title + '. '
          end
        end
      end
      flash[:notice] += @template.pluralize(created, 'New title') + ' added. ' if created > 0
      flash[:notice] += @template.pluralize(title_added, 'Original title') + ' added. ' if title_added > 0
      flash[:notice] += @template.pluralize(local_added, 'Local title') + ' added. ' if local_added > 0
      flash[:notice] += @template.pluralize(added, 'Series number') + ' added. ' if added > 0
      flash[:notice] += @template.pluralize(house_added, 'House Number') + ' added. ' if house_added > 0 
      flash[:notice] += @template.pluralize(promo_added, 'Promo') + ' added. ' if promo_added > 0 
      flash[:notice] += @template.pluralize(created_issues, 'creating title issue') + '. ' if created_issues > 0
      flash[:notice] += @template.pluralize(title_issues, 'original title issue') + '. ' if title_issues > 0
      flash[:notice] += @template.pluralize(local_issues, 'local title issue') + '. ' if local_issues > 0
      flash[:notice] += @template.pluralize(issues, 'Series number issue') + '. ' if issues > 0
      flash[:notice] += @template.pluralize(house_issues, 'House Number issue') + '. ' if house_issues > 0
      flash[:notice] += @template.pluralize(local_fix_added, "Fixed local title") + '. ' if local_fix_added > 0
      flash[:notice] += @template.pluralize(local_fix_issues, "local title issue") + '. ' if local_fix_issues > 0
			flash[:notice] += @template.pluralize(eidr_added, "EIDR") + ' added. ' if eidr_added > 0
      flash[:notice] += notice
    else
      flash[:notice] = "Nothing checked"
    end
    if params[:source] == 'schedule_comparison'
      redirect_to(schedule_comparison_path_with_filter_and_filename_with_recalculate)
    else
      redirect_to(comparison_path_with_filter_and_filename)
    end
  end
  
  def calc (filename_id)
    Comparison.delete_all
    PlaylistLine.full_progs_part1.find_all_by_playlist_filename_id(filename_id).each do |p|
      press = PressLine.find_by_start_and_channel(p.rounded, p.playlist_filename.channel)
      Comparison.add_prog(p, press)
    end
  end
  
  
  # GET /comparisons
  # GET /comparisons.xml
  def index
    calc(params[:filename])

    @filter_display = Comparison.filtered_filter_display
    @colour_display = Comparison.filtered_colour_display
    @filters = Comparison::FILTERS
    @filenames = PlaylistFilename.display
        
    if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
      @comparisons = Comparison.send(params[:show])
      if @comparisons.size == 0
        @comparisons = Comparison.all :order => :rounded
      end
    else
      @comparisons = Comparison.all :order => :rounded
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comparisons }
    end
  end

  # GET /comparisons/1
  # GET /comparisons/1.xml
  def show
    @comparison = Comparison.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comparison }
    end
  end

  # GET /comparisons/new
  # GET /comparisons/new.xml
  def new
    @comparison = Comparison.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comparison }
    end
  end

  # GET /comparisons/1/edit
  def edit
    @comparison = Comparison.find(params[:id])
  end

  # POST /comparisons
  # POST /comparisons.xml
  def create
    @comparison = Comparison.new(params[:comparison])

    respond_to do |format|
      if @comparison.save
        flash[:notice] = 'Comparison was successfully created.'
        format.html { redirect_to(@comparison) }
        format.xml  { render :xml => @comparison, :status => :created, :location => @comparison }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comparison.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comparisons/1
  # PUT /comparisons/1.xml
  def update
    @comparison = Comparison.find(params[:id])

    respond_to do |format|
      if @comparison.update_attributes(params[:comparison])
        flash[:notice] = 'Comparison was successfully updated.'
        format.html { redirect_to(@comparison) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comparison.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comparisons/1
  # DELETE /comparisons/1.xml
  def destroy
    @comparison = Comparison.find(params[:id])
    @comparison.destroy

    respond_to do |format|
      format.html { redirect_to(comparisons_url) }
      format.xml  { head :ok }
    end
  end
end
