class MediaFilesController < ApplicationController
  # GET /media_files
  # GET /media_files.xml
  def index
    @media_files = MediaFile.search(params)
    @media_type_display = MediaType.media_type_display
    @statuses = Status.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  #_{ render :xml => @media_files }
    end
  end

  # GET /media_files/1
  # GET /media_files/1.xml
  def show
    @media_file = MediaFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @media_file }
    end
  end

  # GET /media_files/new
  # GET /media_files/new.xml
  def new
    @media_file = MediaFile.new_with_default_values(params)
    @folders = MediaFolder.all(:order => :name)
    @media_types = MediaType.all
    @statuses = Status.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @media_file }
    end
  end

  # GET /media_files/1/edit
  def edit
    @media_file = MediaFile.find(params[:id])
    @media_file.source = params[:source]
    @media_file.promo_id = params[:promo_id]
    @media_file.trailer_id = params[:trailer_id]
    @media_file.special_preview_id = params[:special_preview_id]
    @folders = MediaFolder.all(:order => :name)
    @media_types = MediaType.all
    @titles = Title.all
    @statuses = Status.all
  end

  # POST /media_files
  # POST /media_files.xml
  def create
    @media_file = MediaFile.new(params[:media_file])
    
    respond_to do |format|
      if @media_file.save
        format.html { 
          if params[:media_file][:source] == 'New Dynamic Special Media'
            dynamic_special_media = DynamicSpecialMedia.find(params[:media_file][:dynamic_special_media_id])
            if dynamic_special_media
              dynamic_special_media.media_file_id = @media_file.id
              if dynamic_special_media.save
                flash[:notice] = 'Dynamic Special Media File was successfully created'
                field = AutomatedDynamicSpecialField.find(params[:media_file][:field_id])
                if field && dynamic_special_media
                  field.the_id = dynamic_special_media.id
                  automated_dynamic_special = AutomatedDynamicSpecial.find_by_id(params[:media_file][:automated_dynamic_special_id])
                  if field.save
                    field.reconcile_the_change()
                    flash[:notice] += ' & added to the field for: ' + automated_dynamic_special.name || 'unknown special'
                  else
                    flash[:notice] += ' but something prevented it being added to the field for: ' + automated_dynamic_special.name || 'unknown special'
                  end
                end
                redirect_to(dynamic_special_media_path(dynamic_special_media, :show_upload_message => true, :automated_dynamic_special_id => automated_dynamic_special))
              else
                flash[:notice] = 'Dynamic Special Media File was NOT created.'
                redirect_to dynamic_special_medias_path
              end
            else
              flash[:notice] = 'Dynamic Special Media File was NOT created.'
              redirect_to(dynamic_special_medias_path)
            end
          else
            flash[:notice] = 'Media File was successfully created.'
            redirect_to(media_files_path_with_type)
          end
        }

        format.xml  { render :xml => @media_file, :status => :created, :location => @media_file }
      else
        @folders = MediaFolder.all(:order => :name)
        @media_types = MediaType.all
        @titles = Title.all
        @statuses = Status.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @media_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /media_files/1
  # PUT /media_files/1.xml
  def update
    @media_file = MediaFile.find(params[:id])

    respond_to do |format|
      if @media_file.update_attributes(params[:media_file])
        flash[:notice] = 'Media File was successfully updated.'

        if @media_file.source == 'promo'
          format.html { redirect_to(promo_path(@media_file.promo_id)) }
          format.xml  { head :ok }
        elsif @media_file.source == 'promo index'
          format.html { redirect_to(promos_path) }
          format.xml  { head :ok }
        elsif @media_file.source == 'trailer'
          keep_first_last_use_in_sync
          format.html { redirect_to(trailer_path(@media_file.trailer_id)) }
          format.xml  { head :ok }
        elsif @media_file.source == 'special preview show'
          format.html { redirect_to(special_preview_path(@media_file.special_preview_id)) }
          format.xml  { head :ok }
        else
          format.html { redirect_to(media_files_path_with_type) }
          format.xml  { head :ok }
        end
      else
        @folders = MediaFolder.all(:order => :name)
        @media_types = MediaType.all
        @titles = Title.all
        @statuses = Status.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @media_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /media_files/1
  # DELETE /media_files/1.xml
  def destroy
    @media_file = MediaFile.find(params[:id])
    @media_file.destroy
  
    respond_to do |format|
      if params[:source] == 'promo'
        format.html { redirect_to(promo_path(params[:promo_id])) }
        format.xml  { head :ok }
      elsif params[:source] == 'promo index'
        format.html { redirect_to(promos_path) }
        format.xml  { head :ok } 
      elsif params[:source] == 'trailer'    
        format.html { redirect_to(trailer_path(params[:trailer_id])) }
        format.xml  { head :ok } 
      elsif params[:source] == 'special preview show'
        format.html { redirect_to(special_preview_path(params[:special_preview_id])) }
        format.xml  { head :ok } 
      elsif params[:source] == 'show'
        format.html { redirect_to(show_on_demand_on_demand_path(:on_demand_id => params[:on_demand_id])) }
        format.xml  { head :ok } 
      else
        format.html { redirect_to(media_files_path_with_type) }
        format.xml  { head :ok }
      end
    end
  end
  
  def upload_file
    if params[:file].nil?
      flash[:notice] = 'Please select a file'
      redirect_to(:back)
    else
      @media_file = MediaFile.upload(params)
      flash[:notice] = @media_file.notice
      if @media_file.issue
        redirect_to :back
      elsif params[:source] == 'promo'
        @promo = Promo.find(@media_file.first_promo_id)
        redirect_to @promo
      elsif params[:source] == 'promo index'
        redirect_to promos_path(:details => true)
      elsif params[:source] == 'special preview show'
        @special_preview = SpecialPreview.find(@media_file.special_preview.id)
        redirect_to @special_preview
      elsif params[:source] == 'show'
        @on_demand = OnDemand.find(params[:on_demand_id])
        redirect_to on_demand_path(@on_demand,  :index_search => params[:search], :index_page => params[:page], 
                                                :on_demand_filename => params[:on_demand_filename], :channel => params[:channel], 
                                                :on_air_date => params[:on_air_date], :show_all => params[:show_all], :show_no_media => params[:show_no_media])
      elsif params[:source] == 'dynamic_special_media'
        if params[:automated_dynamic_special_id]
          redirect_to automated_dynamic_special_path(params[:automated_dynamic_special_id])
        else
          redirect_to dynamic_special_media_path(params[:dynamic_special_media_id])
        end
      else
        redirect_to media_file_path(@media_file, :source => params[:source])
      end
    end
  end
  
  def move_2012
    message = MediaFile.update_2012
    if message.is_a? String
      flash[:notice] = message
    else
      flash[:notice] = "Updated " + message.to_s + " media files"
    end
    redirect_to media_files_path_with_type
  end
  
  def unready
    @media_files = MediaFile.unready
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  #_{ render :xml => @media_files }
    end
  end
  
  # GET /media_files/last_use
  def last_use
    if params[:media_type_display].nil?
      params[:media_type_display] = 'Promo Clip'
    end
    @media_files = MediaFile.past_last_use(params)
    @media_type_display = MediaType.clips_and_stills
    
    respond_to do |format|
      format.html 
      format.xml { render :xml => @media_files }
    end
  end
  
  def change_last_use
    if Useful.date?(params[:new_last_use])
      if params[:media_file_ids] != nil
        added = 0
        params[:media_file_ids].each do |id| 
          if MediaFile.change_last_use(id, params[:new_last_use])
            added += 1
          end
        end
        flash[:notice] = 'Last use updated on ' + @template.pluralize(added, 'media file') if added > 0
      else
        flash[:notice] = "Nothing checked"
      end
    else
      flash[:notice] = "Invalid date"
    end
    redirect_to(media_files_past_last_use_path)
  end

  def keep_first_last_use_in_sync
    trailer = @media_file.trailer
    if trailer
      if (trailer.first_use != @media_file.first_use)||(trailer.last_use != @media_file.last_use)
        trailer.first_use = @media_file.first_use 
        trailer.last_use = @media_file.last_use
        trailer.save
      end
    end
  end
end
