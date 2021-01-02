class CountdownIppsController < ApplicationController
  # GET /countdown_ipps
  # GET /countdown_ipps.xml
  def index
    @countdown_ipps = CountdownIpp.search(params[:search], params[:countdown_date], params[:channel])
    @channel_display = Channel.display
    respond_to do |format|
      format.html # index.html.erb
      format.xml # { render :xml => @countdown_ipps }
    end
  end

  # GET /countdown_ipps/1
  # GET /countdown_ipps/1.xml
  def show
    @countdown_ipp = CountdownIpp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @countdown_ipp }
    end
  end

  # GET /countdown_ipps/new
  # GET /countdown_ipps/new.xml
  def new
    @countdown_ipp = CountdownIpp.new_with_default_times
    @channels = Channel.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @countdown_ipp }
    end
  end

  # GET /countdown_ipps/1/edit
  def edit
    @countdown_ipp = CountdownIpp.find(params[:id])
    @channels = Channel.all
  end

  # POST /countdown_ipps
  # POST /countdown_ipps.xml
  def create
    @countdown_ipp = CountdownIpp.new(params[:countdown_ipp])

    respond_to do |format|
      if @countdown_ipp.save
        flash[:notice] = 'Countdown IPP was successfully created.'
        MediaFile.add_countdown_ipp(@countdown_ipp)
        format.html { redirect_to countdown_ipps_path }
        format.xml  { render :xml => @countdown_ipp, :status => :created, :location => @countdown_ipp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @countdown_ipp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /countdown_ipps/1
  # PUT /countdown_ipps/1.xml
  def update
    @countdown_ipp = CountdownIpp.find(params[:id])

    respond_to do |format|
      if @countdown_ipp.update_attributes(params[:countdown_ipp])
        flash[:notice] = 'Countdown IPP was successfully updated.'
        format.html { redirect_to countdown_ipps_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @countdown_ipp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /countdown_ipps/1
  # DELETE /countdown_ipps/1.xml
  def destroy
    @countdown_ipp = CountdownIpp.find(params[:id])
    @countdown_ipp.media_files.destroy_all
    @countdown_ipp.destroy

    respond_to do |format|
      format.html { redirect_to(countdown_ipps_url) }
      format.xml  { head :ok }
    end
  end

  def create_media_files
    
    @countdown_ipp = CountdownIpp.find(params[:id])
    MediaFile.add_countdown_ipp(@countdown_ipp)
    respond_to do |format|
      format.html {redirect_to @countdown_ipp}
      format.xml  { render :xml => @countdown_ipp }
    end
  end


end
