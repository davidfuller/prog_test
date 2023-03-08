class OnDemandsController < ApplicationController
  # GET /on_demands
  # GET /on_demands.xml
  def index

    @on_demand_filenames = OnDemandFile.display_list
    @channel_display = Channel.channel_display_with_all
    respond_to do |format|
      format.html {index_html(params)}
      format.xml  {index_xml(params)}
    end
  end

  # GET /on_demands/1
  # GET /on_demands/1.xml
  def show
    @on_demand = OnDemand.find(params[:id])
    if params[:search].nil?
      params[:search] = @on_demand.title unless @on_demand.nil?
    end
    @promos = Promo.search_portrait(params[:search], params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @on_demand }
    end
  end

  # GET /on_demands/new
  # GET /on_demands/new.xml
  def new
    @on_demand = OnDemand.new
    @services = Service.all(:order => :name)
    @scheduling_messages = OnDemandScheduling.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @on_demand }
    end
  end

  # GET /on_demands/1/edit
  def edit
    @on_demand = OnDemand.find(params[:id])
    @services = Service.all(:order => :name)
    @scheduling_messages = OnDemandScheduling.all
    if params[:search].nil?
      params[:search] = @on_demand.title unless @on_demand.nil?
    end
    @promos = Promo.search_portrait(params[:search], params[:page])
  end

  # POST /on_demands
  # POST /on_demands.xml
  def create
    @on_demand = OnDemand.new(params[:on_demand])
   
    respond_to do |format|
      if @on_demand.save
        @on_demand.add_any_channels_needed
        flash[:notice] = 'Viaplay Priority was successfully created.'
        format.html { redirect_to(on_demands_path) }
        format.xml  { render :xml => @on_demand, :status => :created, :location => @on_demand }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @on_demand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /on_demands/1
  # PUT /on_demands/1.xml
  def update
    @on_demand = OnDemand.find(params[:id])
    add_channel_enables

    respond_to do |format|
      if @on_demand.update_attributes(params[:on_demand])
        flash[:notice] = 'Viaplay Priority was successfully updated.'
        format.html { redirect_to(on_demands_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @on_demand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /on_demands/1
  # DELETE /on_demands/1.xml
  def destroy
    @on_demand = OnDemand.find(params[:id])
    @on_demand.destroy

    respond_to do |format|
      format.html { redirect_to(on_demands_url(:page => params[:page], :channel => params[:channel], 
                                                :search => params[:search], :on_air_date => params[:on_air_date], :on_demand_filename => params[:on_demand_filename], 
                                                :show_all => params[:show_all])) }
      format.xml  { head :ok }
    end
  end

  def upload_via_file
    uploaded_io = params[:via]
    begin
      filename = Rails.root.join('public','data', 'via', uploaded_io.original_filename)
      create_folder_if_not_exist(filename)
      File.open(filename, 'w') do |file|
        #file.write(Iconv.iconv("UTF-8//IGNORE",  "ISO-8859-1", uploaded_io.read))
        file.write(uploaded_io.read)
      end
      result = process_via_file(filename)
      flash[:notice] = via_upload_message(result)
      redirect_to(on_demands_url)
    rescue NoMethodError
      flash[:notice] = "There has been a problem with the upload. It might be an invalid filename or it could be a problem with the data. Check the sheet and if problems continue contact MuVi2."
      redirect_to(on_demands_path)
    rescue Exception => exc
      logger.error "Error processing priorities sheet #{exc.inspect}"
      flash[:notice] = "Unexpected error. There has been a problem with the upload. It is possible the file is the wrong format. It must be a CSV file. Or it could be a problem with the data. Check the sheet and if problems continue contact MuVi2."
      redirect_to(on_demands_path)
    end
  end

  def add_promo
    @on_demand = OnDemand.find(params[:on_demand_id])
    @on_demand.promo_id = params[:promo_id]
    if @on_demand.save
      flash[:notice] = 'Promo added'
    else
      flash[:notice] = 'Promo not added'
    end
    if params[:source] == 'show'
      logger.debug "=====add promo======"
      redirect_to show_on_demand_on_demand_path(:on_demand_id => @on_demand.id, :source => params[:source],
                                                :index_search => params[:index_search], :index_page => params[:index_page], 
                                                :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
                                                :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media])
    else
      redirect_to edit_on_demand_on_demand_path(:on_demand_id => @on_demand.id, :source => params[:source],
                                                :index_search => params[:index_search], :index_page => params[:index_page], 
                                                :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
                                                :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media])
    end
  end

  def create_promo
    @on_demand = OnDemand.find(params[:on_demand_id])
    result = @on_demand.create_promo
    flash[:notice] = result[:notice]
    logger.debug 'create_promo'
    logger.debug  params[:source]
    if params[:source] == 'show'
      redirect_to show_on_demand_on_demand_path(:on_demand_id => @on_demand.id, :source => params[:source],
                                                :index_search => params[:index_search], :index_page => params[:index_page], 
                                                :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
                                                :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media])
    else
      redirect_to edit_on_demand_on_demand_path(:on_demand_id => @on_demand.id, :source => params[:source],
                                                :index_search => params[:index_search], :index_page => params[:index_page], 
                                                :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
                                                :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media])
    end
  end

  def delete_promo
    @on_demand = OnDemand.find(params[:on_demand_id])
    p = Promo.find(@on_demand.promo_id)
    if p
      p.media_files.destroy_all
      p.destroy
    end
    @on_demand.promo_id = nil
    if @on_demand.save
      flash[:notice] = 'Promo totally deleted'
    else
      flash[:notice] = 'Promo not deleted'
    end
    if params[:source] == 'show'
      redirect_to show_on_demand_on_demand_path(:on_demand_id => @on_demand.id, :source => params[:source],
                                                :index_search => params[:index_search], :index_page => params[:index_page], 
                                                :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
                                                :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media])
    else
      redirect_to edit_on_demand_on_demand_path(:on_demand_id => @on_demand.id, :source => params[:source],
                                                :index_search => params[:index_search], :index_page => params[:index_page], 
                                                :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
                                                :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media])
    end
  end

  def unlink_promo
    @on_demand = OnDemand.find(params[:on_demand_id])
    @on_demand.promo_id = nil
    if @on_demand.save
      flash[:notice] = 'Promo unlinked'
    else
      flash[:notice] = 'Promo not unlinked'
    end
    if params[:source] == 'show'
      redirect_to show_on_demand_on_demand_path(:on_demand_id => @on_demand.id, :source => params[:source],
                                                :index_search => params[:index_search], :index_page => params[:index_page], 
                                                :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
                                                :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media])
    else
      redirect_to edit_on_demand_on_demand_path(:on_demand_id => @on_demand.id, :source => params[:source],
                                                :index_search => params[:index_search], :index_page => params[:index_page], 
                                                :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
                                                :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media])
    end
  end

  def edit_on_demand
    logger.debug 'edit_on_demand'
    logger.debug "@on_demand"
    logger.debug @on_demand
    logger.debug "params[:on_demand_id]"
    logger.debug params[:on_demand_id]
    set_on_demand_info params[:on_demand_id]
    render :action => 'edit', :index_search => params[:index_search], :index_page => params[:index_page], 
    :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
    :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media]
  end

  def show_on_demand
    logger.debug 'show_on_demand'
    logger.debug "@on_demand"
    logger.debug @on_demand
    logger.debug "params[:on_demand_id]"
    logger.debug params[:on_demand_id]
    set_on_demand_info params[:on_demand_id]
    render :action => 'show', :index_search => params[:index_search], :index_page => params[:index_page], 
      :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
      :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media]
  end

  protected

  def create_folder_if_not_exist(filename)
    dirname = File.dirname(filename)
    Dir.mkdir(dirname) unless File.directory?(dirname)
  end

  def process_via_file(filename)
    OnDemand.import(filename)
  end

  def via_upload_message(result)
    message = ''
    message += @template.pluralize(result[:processed], "new item") + ' created. ' if result[:processed] 
    message += @template.pluralize(result[:num_updated], "record") + ' updated. ' if result[:num_updated] && result[:num_updated] > 0
    message += result[:message] if result[:message] && result[:message] != ''
    message += @template.pluralize(result[:num_exists], "record") + ' already present. ' if result[:num_exists] && result[:num_exists] > 0
    message += @template.pluralize(result[:num_not_saved], "record") + ' not saved. ' if result[:num_not_saved] && result[:num_not_saved] > 0
    message += @template.pluralize(result[:rows], "rows") + ' in import. ' if result[:rows] 
    message += @template.pluralize(result[:empty], "rows") + ' were empty/invalid. ' if result[:empty] && result[:empty] > 0
    
    message
  end

  def index_html(params)
    @on_demands = OnDemand.search(params[:search], params[:page], params[:on_demand_filename], params[:on_air_date], params[:channel], params[:show_all], params[:show_no_media])
  end

  def index_xml(params)
    @on_demands = OnDemand.filter_for_xml(params[:end_date], params[:channel])
  end

  def add_channel_enables
    if @on_demand
      @on_demand.channel_on_demands.each do |c|
        if params[:channel_on_demand_ids]
          if params[:channel_on_demand_ids].include? c.id.to_s
            c.enable = true
          else
            c.enable = false
          end
        else
          c.enable = false
        end
        c.save
      end
      flash[:notice] = 'Channels updated. '
    else
      flash[:notice] = "Problem with updating channels. "
    end
  end

  def set_on_demand_info(on_demand_id)
    @on_demand = OnDemand.find(on_demand_id)
    @services = Service.all(:order => :name)
    @show_media = true
    logger.debug 'Session'
    logger.debug session[:info]
    if params[:search].blank?
      if session[:info].blank? || session[:info][:search].nil?
        @promos = Promo.search_portrait('', params[:page])
      else
        @promos = Promo.search_portrait(session[:info][:search], params[:page])
      end
    else
      @promos = Promo.search_portrait(params[:search], params[:page])
    end
    
  end


end
