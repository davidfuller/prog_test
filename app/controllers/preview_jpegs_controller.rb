class PreviewJpegsController < ApplicationController

  def index
    @jpegs = Jpeg.search(params[:folder], params[:search], params[:page])
    @folders = JpegFolder.display

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jpegs }
    end
  end

  def show
    @jpeg = Jpeg.find(params[:id])
    @jpeg_next = Jpeg.next_jpeg(@jpeg, session[:jpeg_search])
    @jpeg_previous = Jpeg.previous_jpeg(@jpeg, session[:jpeg_search]) 
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @jpeg }
    end
  end




end
