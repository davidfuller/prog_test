class PreviewsController < ApplicationController
  def index
    
    if !JpegFolder.rescan_folders
      flash[:notice] = 'Missing JPEG folder on server'
    end
    @jpeg_folders = JpegFolder.search(params[:channel], params[:page])
    @channels = Channel.display
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jpeg_folders }
    end
  end

end
