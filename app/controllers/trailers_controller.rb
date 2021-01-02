class TrailersController < ApplicationController
  # GET /trailers
  # GET /trailers.xml
  def index
    #@trailers = Trailer.all
    @trailer_filenames = TrailerFile.display_list
    
    respond_to do |format|
      format.html {index_html(params)}
      format.xml  {index_xml(params)}
    end
  end

  # GET /trailers/1
  # GET /trailers/1.xml
  def show
    @trailer = Trailer.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trailer }
    end
  end

  # GET /trailers/new
  # GET /trailers/new.xml
  def new
    @trailer_files = TrailerFile.all
    @trailer = Trailer.new
    @next_monday = Trailer.next_monday(1)
    @plus_two_weeks = Trailer.next_monday(3)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trailer }
    end
  end

  # GET /trailers/1/edit
  def edit
    @trailer_files = TrailerFile.all
    @next_monday = Trailer.next_monday(1)
    @plus_two_weeks = Trailer.next_monday(3)
    @trailer = Trailer.find(params[:id])
  end

  # POST /trailers
  # POST /trailers.xml
  def create
    @trailer = Trailer.new(params[:trailer])
    respond_to do |format|
      if @trailer.save
        @trailer.add_any_channels_needed
        flash[:notice] = 'Trailer was successfully created.'
        format.html { redirect_to(trailers_url) }
        format.xml  { render :xml => @trailer, :status => :created, :location => @trailer }
      else
        format.html { @trailer_files = TrailerFile.all
                      @next_monday = Trailer.next_monday(1)
                      @plus_two_weeks = Trailer.next_monday(3)
                      render :action => "new" }
        format.xml  { render :xml => @trailer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trailers/1
  # PUT /trailers/1.xml
  def update
    @trailer = Trailer.find(params[:id])
    add_channel_enables
    respond_to do |format|
      if @trailer.update_attributes(params[:trailer])
        keep_first_last_use_in_sync
        flash[:notice] = 'Trailer was successfully updated. '
        
        format.html { redirect_to(trailers_url) }
        format.xml  { head :ok }
      else
        format.html {   @trailer_files = TrailerFile.all
                        @next_monday = Trailer.next_monday(1)
                        @plus_two_weeks = Trailer.next_monday(3)
                        render :action => "edit" }
        format.xml  { render :xml => @trailer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trailers/1
  # DELETE /trailers/1.xml
  def destroy
    @trailer = Trailer.find(params[:id])
    @trailer.destroy

    respond_to do |format|
      format.html { redirect_to(trailers_url(:page => params[:page], :search => params[:search], :show_choice => params[:show_choice], :trailer_filename => params[:trailer_filename], :on_air_date => params[:on_air_date])) }
      format.xml  { head :ok }
    end
  end

  def upload_trailer_file
    uploaded_io = params[:trailer]
    begin
      filename = Rails.root.join('public','data', 'trailer', uploaded_io.original_filename)
      create_folder_if_not_exist(filename)
      File.open(filename, 'w') do |file|
        #file.write(Iconv.iconv("UTF-8//IGNORE",  "ISO-8859-1", uploaded_io.read))
        file.write()
      end
      result = process_trailer_file(filename)
      flash[:notice] = trailer_upload_message(result)
      redirect_to(trailers_url)
    rescue NoMethodError
      flash[:notice] = "Invalid filename"
      redirect_to(trailers_path)
    rescue Exception => exc
      logger.error "Error processing Trailer File #{exc.inspect}"
      flash[:notice] = "Unexpected error. It is possible the file is the wrong format"
      redirect_to(trailers_path)
    end
    
  end
  def process_trailer_file (filename)
    
    file=File.new(filename, "r")
    file_basename = File.basename(filename)
    trailer_filename = TrailerFile.find_by_filename(file_basename)
    if !trailer_filename
      trailer_filename = TrailerFile.new
      trailer_filename.filename = file_basename
    end
    
    trailer_filename.uploaded = Time.current
    if trailer_filename.save
      file_id = trailer_filename.id
      logger.debug file_id
    end

    line=file.gets
    status = Trailer.check_header(line)
    logger.debug status
    if status[:status]
      added = 0
      updated = 0
      already_present = 0
      failed = 0

      while (line=file.gets)
        trailer = Trailer.new
        result = trailer.add_line(line, file_id)
        if result[:success]
          added = added + result[:added]
          updated = updated + result[:updated]
          already_present = already_present + result[:already_present]
        else
          failed = failed + 1
        end
      end
      { :already_present => already_present, :updated => updated, :added => added, :failed => failed }
    else
      {:message => status[:message]}
    end
  end

  def add_multiple
    @trailer = Trailer.find(params[:id])
    if @trailer
      @trailer.channel_trailers.each do |c|
        if params[:channel_trailer_ids]
          if params[:channel_trailer_ids].include? c.id.to_s
            c.enable = true
          else
            c.enable = false
          end
        else
          c.enable = false
        end
        c.save
      end
      flash[:notice] = 'Channels updated'
      redirect_to @trailer
    else
      redirect_to trailers_url
    end
  end

  def add_channel_enables
    if @trailer
      @trailer.channel_trailers.each do |c|
        if params[:channel_trailer_ids]
          if params[:channel_trailer_ids].include? c.id.to_s
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

  def toggle_channel
    @trailer = Trailer.find(params[:id])
    if @trailer
      language = Language.find_by_name(params[:language])
      logger.debug language
      if language
        @trailer.channel_trailers.each do |c|
          if c.channel.language.id == language.id
            c.enable = !c.enable
          end
          c.save
        end
        flash[:notice] = 'Channels updated'
      end
      redirect_to edit_trailer_path(@trailer)
    else
      redirect_to trailers_url
    end
  end

  def auto_enable
    @trailer= Trailer.find(params[:id])
    page = params[:page]
    trailer_filename = params[:trailer_filename]
    search = params[:search]
    if @trailer
      if @trailer.auto_enable
        flash[:notice] = @trailer.house_number + ' has been auto enabled. '
      else
        flash[:notice] = @trailer.house_number + ' failed auto enabling. '
        @trailer.errors.full_messages.each do |e|
          flash[:notice] += e
        end
      end
    end
    redirect_to trailers_url(:page => page, :trailer_filename => trailer_filename, :search => search)
  end

  def add_media_file
    @trailer= Trailer.find(params[:id])
    if @trailer
      result = @trailer.add_media
      flash[:notice] = result[:message]
    end
    redirect_to @trailer
  end

  def delete_all_not_available
    num_deleted = Trailer.destroy_all('enable = 0').count
    num_deleted += Trailer.destroy_all('enable IS NULL').count
    flash[:notice] = @template.pluralize(num_deleted, "Trailer") + " have been deleted"
    redirect_to trailers_url
  end

  def upload_diva_search_file
    @trailer = Trailer.find(params[:id])
    if @trailer
      result = DivaData.media_search_individual(@trailer)
      flash[:notice] = result[:flash_notice]
      if result[:processed]
        redirect_to @trailer
      else
        redirect_to(trailers_path)
      end    
    else
      redirect_to(trailers_path)
    end
  end

  def upload_diva_workflow_file
    @trailer = Trailer.find(params[:id])
    if @trailer
      if params[:workflow]
        result = DivaData.workflow_individual(@trailer)
      else
        result = DivaData.workflow_update_individual(@trailer)
      end
      flash[:notice] = result[:flash_notice]
      if result[:processed]
        redirect_to @trailer
      else
        redirect_to(trailers_path)
      end    
    else
      redirect_to(trailers_path)
    end
  end

  def diva_media_search
    DivaData.media_search
    redirect_to trailers_path(:show_choice => 3)
  end

  def diva_workflow
    DivaData.workflow
    redirect_to trailers_path(:show_choice => 4)
  end

  def diva_workflow_update
    DivaData.workflow_update
    redirect_to trailers_path(:show_choice => 5)
  end

  def delete_diva_references
    Trailer.delete_orphaned_diva_data_references
    redirect_to trailers_path(:search => params[:search], :trailer_filename => params[:trailer_filename], :on_air_date => params[:on_air_date], :show_choice => params[:show_choice])
  end

protected
  
  def index_html(params)
    @trailers = Trailer.search(params[:search], params[:page], params[:trailer_filename], params[:on_air_date], params[:show_choice])
  end

  def index_xml(params)
    @trailers = Trailer.filter_with_media_id(params[:last_use], params[:channel])
  end
  
  def create_folder_if_not_exist(filename)
    
    dirname = File.dirname(filename)
    Dir.mkdir(dirname) unless File.directory?(dirname)

  end

private
  def trailer_upload_message(result)
    message = ''
    message += @template.pluralize(result[:added], "trailer") + ' added. ' if result[:added] && result[:added] > 0
    message += @template.pluralize(result[:updated], "trailer") + ' updated. ' if result[:updated] && result[:updated] > 0
    message += @template.pluralize(result[:already_present], "trailer") + ' already present. ' if result[:already_present] && result[:already_present] > 0
    message += @template.pluralize(result[:failed], "trailer") + ' failed. ' if result[:failed] && result[:failed] > 0
    message += result[:message] if result[:message]
    message
  end

  def keep_first_last_use_in_sync
    media = @trailer.media_file
    if media
      if (@trailer.first_use != media.first_use)||(@trailer.last_use != media.last_use)
        media.first_use = @trailer.first_use
        media.last_use = @trailer.last_use
        media.save
      end
    end
  end
  
end
