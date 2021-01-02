class ChannelSpecialPreviewsController < ApplicationController
  # GET /channel_special_previews
  # GET /channel_special_previews.xml
  def index
    @channel_special_previews = ChannelSpecialPreview.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @channel_special_previews }
    end
  end

  # GET /channel_special_previews/1
  # GET /channel_special_previews/1.xml
  def show
    @channel_special_preview = ChannelSpecialPreview.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @channel_special_preview }
    end
  end

  # GET /channel_special_previews/new
  # GET /channel_special_previews/new.xml
  def new
    @channel_special_preview = ChannelSpecialPreview.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @channel_special_preview }
    end
  end

  # GET /channel_special_previews/1/edit
  def edit
    @channel_special_preview = ChannelSpecialPreview.find(params[:id])
  end

  # POST /channel_special_previews
  # POST /channel_special_previews.xml
  def create
    @channel_special_preview = ChannelSpecialPreview.new(params[:channel_special_preview])

    respond_to do |format|
      if @channel_special_preview.save
        flash[:notice] = 'ChannelSpecialPreview was successfully created.'
        format.html { redirect_to(@channel_special_preview) }
        format.xml  { render :xml => @channel_special_preview, :status => :created, :location => @channel_special_preview }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @channel_special_preview.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /channel_special_previews/1
  # PUT /channel_special_previews/1.xml
  def update
    @channel_special_preview = ChannelSpecialPreview.find(params[:id])

    respond_to do |format|
      if @channel_special_preview.update_attributes(params[:channel_special_preview])
        flash[:notice] = 'ChannelSpecialPreview was successfully updated.'
        format.html { redirect_to(@channel_special_preview) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @channel_special_preview.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_special_previews/1
  # DELETE /channel_special_previews/1.xml
  def destroy
    @channel_special_preview = ChannelSpecialPreview.find(params[:id])
    @channel_special_preview.destroy

    respond_to do |format|
      format.html { redirect_to(channel_special_previews_url) }
      format.xml  { head :ok }
    end
  end
end
