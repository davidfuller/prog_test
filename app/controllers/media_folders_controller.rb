class MediaFoldersController < ApplicationController
  # GET /media_folders
  # GET /media_folders.xml
  def index
    @media_folders = MediaFolder.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @media_folders }
    end
  end

  # GET /media_folders/1
  # GET /media_folders/1.xml
  def show
    @media_folder = MediaFolder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @media_folder }
    end
  end

  # GET /media_folders/new
  # GET /media_folders/new.xml
  def new
    @media_folder = MediaFolder.new
    @channels = Channel.all
    @aspects = Aspect.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @media_folder }
    end
  end

  # GET /media_folders/1/edit
  def edit
    @media_folder = MediaFolder.find(params[:id])
    @channels = Channel.all
    @aspects = Aspect.all
  end

  # POST /media_folders
  # POST /media_folders.xml
  def create
    @media_folder = MediaFolder.new(params[:media_folder])

    respond_to do |format|
      if @media_folder.save
        flash[:notice] = 'Media Folder was successfully created.'
        format.html { redirect_to(media_folders_url) }
        format.xml  { render :xml => @media_folder, :status => :created, :location => @media_folder }
      else
        @channels = Channel.all
        @aspects = Aspect.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @media_folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /media_folders/1
  # PUT /media_folders/1.xml
  def update
    @media_folder = MediaFolder.find(params[:id])

    respond_to do |format|
      if @media_folder.update_attributes(params[:media_folder])
        flash[:notice] = 'Media Folder was successfully updated.'
        format.html { redirect_to(media_folders_url) }
        format.xml  { head :ok }
      else
        @channels = Channel.all
        @aspects = Aspect.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @media_folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /media_folders/1
  # DELETE /media_folders/1.xml
  def destroy
    @media_folder = MediaFolder.find(params[:id])
    @media_folder.destroy

    respond_to do |format|
      format.html { redirect_to(media_folders_url) }
      format.xml  { head :ok }
    end
  end
  

end
