class PlaylistFilenamesController < ApplicationController
  # GET /playlist_filenames
  # GET /playlist_filenames.xml
  def index
    @playlist_filenames = PlaylistFilename.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @playlist_filenames }
    end
  end

  # GET /playlist_filenames/1
  # GET /playlist_filenames/1.xml
  def show
    @playlist_filename = PlaylistFilename.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @playlist_filename }
    end
  end

  # GET /playlist_filenames/new
  # GET /playlist_filenames/new.xml
  def new
    @playlist_filename = PlaylistFilename.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @playlist_filename }
    end
  end

  # GET /playlist_filenames/1/edit
  def edit
    @playlist_filename = PlaylistFilename.find(params[:id])
  end

  # POST /playlist_filenames
  # POST /playlist_filenames.xml
  def create
    @playlist_filename = PlaylistFilename.new(params[:playlist_filename])

    respond_to do |format|
      if @playlist_filename.save
        flash[:notice] = 'PlaylistFilename was successfully created.'
        format.html { redirect_to(@playlist_filename) }
        format.xml  { render :xml => @playlist_filename, :status => :created, :location => @playlist_filename }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @playlist_filename.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /playlist_filenames/1
  # PUT /playlist_filenames/1.xml
  def update
    @playlist_filename = PlaylistFilename.find(params[:id])

    respond_to do |format|
      if @playlist_filename.update_attributes(params[:playlist_filename])
        flash[:notice] = 'PlaylistFilename was successfully updated.'
        format.html { redirect_to(@playlist_filename) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @playlist_filename.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /playlist_filenames/1
  # DELETE /playlist_filenames/1.xml
  def destroy
    @playlist_filename = PlaylistFilename.find(params[:id])
    @playlist_filename.destroy

    respond_to do |format|
      format.html { redirect_to(playlist_filenames_url) }
      format.xml  { head :ok }
    end
  end
end
