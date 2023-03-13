class SportsIppsController < ApplicationController
  # GET /sports_ipps
  # GET /sports_ipps.xml
  def index
    @sports_ipps = SportsIpp.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sports_ipps }
    end
  end

  # GET /sports_ipps/1
  # GET /sports_ipps/1.xml
  def show
    @sports_ipp = SportsIpp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sports_ipp }
    end
  end

  # GET /sports_ipps/new
  # GET /sports_ipps/new.xml
  def new
    @sports_ipp = SportsIpp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sports_ipp }
    end
  end

  # GET /sports_ipps/1/edit
  def edit
    @sports_ipp = SportsIpp.find(params[:id])
  end

  # POST /sports_ipps
  # POST /sports_ipps.xml
  def create
    @sports_ipp = SportsIpp.new(params[:sports_ipp])

    respond_to do |format|
      if @sports_ipp.save
        flash[:notice] = 'SportsIpp was successfully created.'
        format.html { redirect_to(@sports_ipp) }
        format.xml  { render :xml => @sports_ipp, :status => :created, :location => @sports_ipp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sports_ipp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sports_ipps/1
  # PUT /sports_ipps/1.xml
  def update
    @sports_ipp = SportsIpp.find(params[:id])

    respond_to do |format|
      if @sports_ipp.update_attributes(params[:sports_ipp])
        flash[:notice] = 'SportsIpp was successfully updated.'
        format.html { redirect_to(@sports_ipp) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sports_ipp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sports_ipps/1
  # DELETE /sports_ipps/1.xml
  def destroy
    @sports_ipp = SportsIpp.find(params[:id])
    @sports_ipp.destroy

    respond_to do |format|
      format.html do
        if params[:automated_dynamic_special_id]
          flash[:notice] = "Request has been cancelled"
          redirect_to automated_dynamic_special_path(params[:automated_dynamic_special_id])
        else 
          redirect_to sports_ipps_url  
        end
      end
      format.xml  { head :ok }
    end
  end

  def create_from_automated_dynamic_special
    ads = AutomatedDynamicSpecial.find_by_id(params[:automated_dynamic_special_id])
    if ads
      sports_ipp = SportsIpp.new
      sports_ipp.name = SportsIpp.new_name(ads.name)
      logger.debug(sports_ipp.name)
      if sports_ipp.save
        result = sports_ipp.add_preview_media
        if result[:success]
          result = sports_ipp.add_sports_ipp_media
          if result[:success]
            ads.sports_ipp_id = sports_ipp.id
            if ads.save
              flash[:notice] = 'Sports IPP requested'
            else
              flash[:notice] = 'Sports IPP could not be created for this special. Could not connect to this special'
            end
          else
              flash[:notice] = 'Sports IPP could not be created for this special. Could not connect to this special'
          end
        else
          flash[:notice] = 'Sports IPP Preview movie could not be created for this special. The media could not be added to the preview'
        end
      else
        flash[:notice] = 'Sports IPP Preview movie could not be created for this special. The preview record could not be created.'
      end
      redirect_to automated_dynamic_special_path(ads)
    else
      flash[:notice] = "Issue creating Sports IPP preview movie"
      redirect_to automated_dynamic_specials_url
    end
  end
end
