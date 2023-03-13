class SportsIppStatusesController < ApplicationController
  # GET /sports_ipp_statuses
  # GET /sports_ipp_statuses.xml
  def index
    @sports_ipp_statuses = SportsIppStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sports_ipp_statuses }
    end
  end

  # GET /sports_ipp_statuses/1
  # GET /sports_ipp_statuses/1.xml
  def show
    @sports_ipp_status = SportsIppStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sports_ipp_status }
    end
  end

  # GET /sports_ipp_statuses/new
  # GET /sports_ipp_statuses/new.xml
  def new
    @sports_ipp_status = SportsIppStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sports_ipp_status }
    end
  end

  # GET /sports_ipp_statuses/1/edit
  def edit
    @sports_ipp_status = SportsIppStatus.find(params[:id])
  end

  # POST /sports_ipp_statuses
  # POST /sports_ipp_statuses.xml
  def create
    @sports_ipp_status = SportsIppStatus.new(params[:sports_ipp_status])

    respond_to do |format|
      if @sports_ipp_status.save
        flash[:notice] = 'SportsIppStatus was successfully created.'
        format.html { redirect_to(@sports_ipp_status) }
        format.xml  { render :xml => @sports_ipp_status, :status => :created, :location => @sports_ipp_status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sports_ipp_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sports_ipp_statuses/1
  # PUT /sports_ipp_statuses/1.xml
  def update
    @sports_ipp_status = SportsIppStatus.find(params[:id])

    respond_to do |format|
      if @sports_ipp_status.update_attributes(params[:sports_ipp_status])
        flash[:notice] = 'SportsIppStatus was successfully updated.'
        format.html { redirect_to(@sports_ipp_status) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sports_ipp_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sports_ipp_statuses/1
  # DELETE /sports_ipp_statuses/1.xml
  def destroy
    @sports_ipp_status = SportsIppStatus.find(params[:id])
    @sports_ipp_status.destroy

    respond_to do |format|
      format.html { redirect_to(sports_ipp_statuses_url) }
      format.xml  { head :ok }
    end
  end
end
