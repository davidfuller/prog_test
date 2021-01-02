class OnDemandSchedulingsController < ApplicationController
  # GET /on_demand_schedulings
  # GET /on_demand_schedulings.xml
  def index
    @on_demand_schedulings = OnDemandScheduling.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @on_demand_schedulings }
    end
  end

  # GET /on_demand_schedulings/1
  # GET /on_demand_schedulings/1.xml
  def show
    @on_demand_scheduling = OnDemandScheduling.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @on_demand_scheduling }
    end
  end

  # GET /on_demand_schedulings/new
  # GET /on_demand_schedulings/new.xml
  def new
    @on_demand_scheduling = OnDemandScheduling.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @on_demand_scheduling }
    end
  end

  # GET /on_demand_schedulings/1/edit
  def edit
    @on_demand_scheduling = OnDemandScheduling.find(params[:id])
  end

  # POST /on_demand_schedulings
  # POST /on_demand_schedulings.xml
  def create
    @on_demand_scheduling = OnDemandScheduling.new(params[:on_demand_scheduling])

    respond_to do |format|
      if @on_demand_scheduling.save
        flash[:notice] = 'OnDemandScheduling was successfully created.'
        format.html { redirect_to(@on_demand_scheduling) }
        format.xml  { render :xml => @on_demand_scheduling, :status => :created, :location => @on_demand_scheduling }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @on_demand_scheduling.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /on_demand_schedulings/1
  # PUT /on_demand_schedulings/1.xml
  def update
    @on_demand_scheduling = OnDemandScheduling.find(params[:id])

    respond_to do |format|
      if @on_demand_scheduling.update_attributes(params[:on_demand_scheduling])
        flash[:notice] = 'OnDemandScheduling was successfully updated.'
        format.html { redirect_to(@on_demand_scheduling) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @on_demand_scheduling.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /on_demand_schedulings/1
  # DELETE /on_demand_schedulings/1.xml
  def destroy
    @on_demand_scheduling = OnDemandScheduling.find(params[:id])
    @on_demand_scheduling.destroy

    respond_to do |format|
      format.html { redirect_to(on_demand_schedulings_url) }
      format.xml  { head :ok }
    end
  end
end
