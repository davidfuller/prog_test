class DynamicSpecialMediasController < ApplicationController
  # GET /dynamic_special_medias
  # GET /dynamic_special_medias.xml
  def index
    @dynamic_special_medias = DynamicSpecialMedia.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dynamic_special_medias }
    end
  end

  # GET /dynamic_special_medias/1
  # GET /dynamic_special_medias/1.xml
  def show
    @dynamic_special_media = DynamicSpecialMedia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dynamic_special_media }
    end
  end

  # GET /dynamic_special_medias/new
  # GET /dynamic_special_medias/new.xml
  def new
    @dynamic_special_media = DynamicSpecialMedia.new
    @special_types = DynamicSpecialImageSpec.all(:conditions => {:promo => true})
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dynamic_special_media }
    end
  end

  # GET /dynamic_special_medias/1/edit
  def edit
    @special_types = DynamicSpecialImageSpec.all(:conditions => {:promo => true})
    @dynamic_special_media = DynamicSpecialMedia.find(params[:id])
    params[:media_type_display] = 'Special Media'
    params[:spec_id] = @dynamic_special_media.dynamic_special_image_spec_id
    @medias = MediaFile.search(params)
  end

  # POST /dynamic_special_medias
  # POST /dynamic_special_medias.xml
  def create
    @dynamic_special_media = DynamicSpecialMedia.new(params[:dynamic_special_media])

    respond_to do |format|
      if @dynamic_special_media.save
        flash[:notice] = 'Dynamic Special Media was successfully created. Now add the image.'
        format.html { redirect_to(new_media_file_path(:dynamic_special_media_id => @dynamic_special_media.id, :spec_id => @dynamic_special_media.dynamic_special_image_spec_id || 1)) }
        format.xml  { render :xml => @dynamic_special_media, :status => :created, :location => @dynamic_special_media }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dynamic_special_media.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dynamic_special_medias/1
  # PUT /dynamic_special_medias/1.xml
  def update
    @dynamic_special_media = DynamicSpecialMedia.find(params[:id])

    respond_to do |format|
      if @dynamic_special_media.update_attributes(params[:dynamic_special_media])
        flash[:notice] = 'DynamicSpecialMedia was successfully updated.'
        format.html { redirect_to(@dynamic_special_media) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dynamic_special_media.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dynamic_special_medias/1
  # DELETE /dynamic_special_medias/1.xml
  def destroy
    @dynamic_special_media = DynamicSpecialMedia.find(params[:id])
    @dynamic_special_media.destroy

    respond_to do |format|
      format.html { redirect_to(dynamic_special_medias_url) }
      format.xml  { head :ok }
    end
  end

  def replace_media
    dynamic_special_media = DynamicSpecialMedia.find(params[:id])
    if dynamic_special_media
      dynamic_special_media.media_file_id = params[:media_file_id]
      if dynamic_special_media.save
        flash[:notice] = 'Media File successfully updated'
      else
        flash[:notice] = 'Issue with updating file'
      end
    else
      flash[:notice] = 'Issue finding dynamic special media'
    end
    redirect_to edit_dynamic_special_media_path({:id => params[:id], :search => params[:search], :page => params[:page]})
  end
end