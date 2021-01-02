class JpegFoldersController < ApplicationController
  # GET /jpeg_folders
  # GET /jpeg_folders.xml
  def index
    
    JpegFolder.rescan_folders
    @jpeg_folders = JpegFolder.search(params[:channel], params[:page])
    @channels = Channel.display

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jpeg_folders }
    end
  end

  # GET /jpeg_folders/1
  # GET /jpeg_folders/1.xml
  def show
    @jpeg_folder = JpegFolder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @jpeg_folder }
    end
  end

  # GET /jpeg_folders/new
  # GET /jpeg_folders/new.xml
  def new
    @jpeg_folder = JpegFolder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @jpeg_folder }
    end
  end

  # GET /jpeg_folders/1/edit
  def edit
    @jpeg_folder = JpegFolder.find(params[:id])
  end

  # POST /jpeg_folders
  # POST /jpeg_folders.xml
  def create
    @jpeg_folder = JpegFolder.new(params[:jpeg_folder])

    respond_to do |format|
      if @jpeg_folder.save
        flash[:notice] = 'JpegFolder was successfully created.'
        format.html { redirect_to(@jpeg_folder) }
        format.xml  { render :xml => @jpeg_folder, :status => :created, :location => @jpeg_folder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @jpeg_folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jpeg_folders/1
  # PUT /jpeg_folders/1.xml
  def update
    @jpeg_folder = JpegFolder.find(params[:id])

    respond_to do |format|
      if @jpeg_folder.update_attributes(params[:jpeg_folder])
        flash[:notice] = 'JpegFolder was successfully updated.'
        format.html { redirect_to(@jpeg_folder) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @jpeg_folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jpeg_folders/1
  # DELETE /jpeg_folders/1.xml
  def destroy
    @jpeg_folder = JpegFolder.find(params[:id])
    @jpeg_folder.destroy

    respond_to do |format|
      format.html { redirect_to(jpeg_folders_url) }
      format.xml  { head :ok }
    end
  end
end
