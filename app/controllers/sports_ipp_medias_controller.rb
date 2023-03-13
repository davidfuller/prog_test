class SportsIppMediasController < ApplicationController
  # GET /sports_ipp_medias
  # GET /sports_ipp_medias.xml
  def index
    @sports_ipp_medias = SportsIppMedia.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sports_ipp_medias }
    end
  end

  # GET /sports_ipp_medias/1
  # GET /sports_ipp_medias/1.xml
  def show
    @sports_ipp_media = SportsIppMedia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sports_ipp_media }
    end
  end

  # GET /sports_ipp_medias/new
  # GET /sports_ipp_medias/new.xml
  def new
    @sports_ipp_media = SportsIppMedia.new
    @statuses = SportsIppStatus.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sports_ipp_media }
    end
  end

  # GET /sports_ipp_medias/1/edit
  def edit
    @sports_ipp_media = SportsIppMedia.find(params[:id])
    @statuses = SportsIppStatus.all
  end

  # POST /sports_ipp_medias
  # POST /sports_ipp_medias.xml
  def create
    @sports_ipp_media = SportsIppMedia.new(params[:sports_ipp_media])

    respond_to do |format|
      if @sports_ipp_media.save
        flash[:notice] = 'SportsIppMedia was successfully created.'
        format.html { redirect_to(@sports_ipp_media) }
        format.xml  { render :xml => @sports_ipp_media, :status => :created, :location => @sports_ipp_media }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sports_ipp_media.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sports_ipp_medias/1
  # PUT /sports_ipp_medias/1.xml
  def update
    @sports_ipp_media = SportsIppMedia.find(params[:id])

    respond_to do |format|
      if @sports_ipp_media.update_attributes(params[:sports_ipp_media])
        flash[:notice] = 'SportsIppMedia was successfully updated.'
        format.html { redirect_to(@sports_ipp_media) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sports_ipp_media.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sports_ipp_medias/1
  # DELETE /sports_ipp_medias/1.xml
  def destroy
    @sports_ipp_media = SportsIppMedia.find(params[:id])
    @sports_ipp_media.destroy

    respond_to do |format|
      format.html { redirect_to(sports_ipp_medias_url) }
      format.xml  { head :ok }
    end
  end

  def upload_file
    if params[:file].nil?
      flash[:notice] = 'Please select a file'
      redirect_to(:back)
    else
      @sports_ipp_media = SportsIppMedia.upload(params)
      flash[:notice] = @sports_ipp_media.notice
      if @sports_ipp_media.issue
        redirect_to :back
      else
        redirect_to sports_ipp_path(@sports_ipp_media.sports_ipp)
      end
    end
  end
end
