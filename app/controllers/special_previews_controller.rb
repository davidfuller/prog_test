class SpecialPreviewsController < ApplicationController
  # GET /special_previews
  # GET /special_previews.xml
  def index
    
    @channel_display = Channel.channel_display_with_all
    respond_to do |format|
      format.html {index_html(params)}
      format.xml  {index_xml(params)}
    end
  end

  # GET /special_previews/1
  # GET /special_previews/1.xml
  def show
    @special_preview = SpecialPreview.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @special_preview }
    end
  end

  # GET /special_previews/new
  # GET /special_previews/new.xml
  def new
    @special_preview = SpecialPreview.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @special_preview }
    end
  end

  # GET /special_previews/1/edit
  def edit
    @special_preview = SpecialPreview.find(params[:id])
  end

  # POST /special_previews
  # POST /special_previews.xml
  def create
    @special_preview = SpecialPreview.new(params[:special_preview])

    respond_to do |format|
      if @special_preview.save
        result = @special_preview.add_media
        flash[:notice] = result[:message]
        @special_preview.add_any_channels_needed
        flash[:notice] += 'Special Preview was successfully created.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @special_preview, :status => :created, :location => @special_preview }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @special_preview.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /special_previews/1
  # PUT /special_previews/1.xml
  def update
    @special_preview = SpecialPreview.find(params[:id])
    add_channel_enables
    respond_to do |format|
      if @special_preview.update_attributes(params[:special_preview])
        flash[:notice] += 'Special Preview was successfully updated.'
        format.html { redirect_to(@special_preview) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @special_preview.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /special_previews/1
  # DELETE /special_previews/1.xml
  def destroy
    @special_preview = SpecialPreview.find(params[:id])
    @special_preview.destroy

    respond_to do |format|
      format.html do
        if params[:automated_dynamic_special_id]
          flash[:notice] = "Request has been cancelled"
          redirect_to automated_dynamic_special_path(params[:automated_dynamic_special_id])
        else
          redirect_to special_previews_url
        end
      end 
      format.xml  { head :ok }
    end
  end

  def add_media_file
    @special_preview = SpecialPreview.find(params[:id])
    if @special_preview
      result = @special_preview.add_media
      flash[:notice] = result[:message]
    end
    redirect_to @special_preview
  end

  def toggle_channel
    @special_preview = SpecialPreview.find(params[:id])
    if @special_preview
      language = Language.find_by_name(params[:language])
      logger.debug language
      if language
        @special_preview.channel_special_previews.each do |c|
          if c.channel.language.id == language.id
            c.enable = !c.enable
          end
          c.save
        end
        flash[:notice] = 'Channels updated'
      end
      redirect_to edit_special_preview_path(@special_preview)
    else
      redirect_to special_previews_url
    end
  end

  def add_channel_enables
    if @special_preview
      @special_preview.channel_special_previews.each do |c|
        if params[:channel_special_preview_ids]
          if params[:channel_special_preview_ids].include? c.id.to_s
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

  def create_from_automated_dynamic_special
    ads = AutomatedDynamicSpecial.find_by_id(params[:automated_dynamic_special_id])
    if ads
      special_preview = SpecialPreview.new
      special_preview.name = SpecialPreview.new_name(ads.name)
      logger.debug(special_preview.name)
      if special_preview.save
        result = special_preview.add_media
        if result[:success]
          special_preview.add_automated_dynamic_special_channel(ads.channel_id)
          ads.special_preview_id = special_preview.id
          if ads.save
            flash[:notice] = 'Preview movie requested'
          else
            flash[:notice] = 'Preview movie could not be created for this special. Could not connect to this special'
          end
        else
          flash[:notice] = 'Preview movie could not be created for this special. The media could not be added to the preview'
        end
      else
        flash[:notice] = 'Preview movie could not be created for this special. The preview record could not be created.'
      end
      redirect_to automated_dynamic_special_path(ads)
    else
      flash[:notice] = "Issue creating preview movie"
      redirect_to automated_dynamic_specials_url
    end
  end

  def recent
    @special_previews = SpecialPreview.recent(params)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  #_{ render :xml => @media_files }
    end
  end

  protected
  
  def index_html(params)
    @special_previews = SpecialPreview.search(params[:search], params[:page], params[:channel])
  end
  def index_xml(params)
    @special_previews = SpecialPreview.all
  end

end
