class ChannelTrailersController < ApplicationController
  # GET /channel_trailers
  # GET /channel_trailers.xml
  def index
    @channel_trailers = ChannelTrailer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @channel_trailers }
    end
  end

  # GET /channel_trailers/1
  # GET /channel_trailers/1.xml
  def show
    @channel_trailer = ChannelTrailer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @channel_trailer }
    end
  end

  # GET /channel_trailers/new
  # GET /channel_trailers/new.xml
  def new
    @channel_trailer = ChannelTrailer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @channel_trailer }
    end
  end

  # GET /channel_trailers/1/edit
  def edit
    @channel_trailer = ChannelTrailer.find(params[:id])
  end

  # POST /channel_trailers
  # POST /channel_trailers.xml
  def create
    @channel_trailer = ChannelTrailer.new(params[:channel_trailer])

    respond_to do |format|
      if @channel_trailer.save
        flash[:notice] = 'ChannelTrailer was successfully created.'
        format.html { redirect_to(@channel_trailer) }
        format.xml  { render :xml => @channel_trailer, :status => :created, :location => @channel_trailer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @channel_trailer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /channel_trailers/1
  # PUT /channel_trailers/1.xml
  def update
    @channel_trailer = ChannelTrailer.find(params[:id])

    respond_to do |format|
      if @channel_trailer.update_attributes(params[:channel_trailer])
        flash[:notice] = 'ChannelTrailer was successfully updated.'
        format.html { redirect_to(@channel_trailer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @channel_trailer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_trailers/1
  # DELETE /channel_trailers/1.xml
  def destroy
    @channel_trailer = ChannelTrailer.find(params[:id])
    @channel_trailer.destroy

    respond_to do |format|
      format.html { redirect_to(channel_trailers_url) }
      format.xml  { head :ok }
    end
  end
end
