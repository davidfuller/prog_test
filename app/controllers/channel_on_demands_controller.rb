class ChannelOnDemandsController < ApplicationController
  # GET /channel_on_demands
  # GET /channel_on_demands.xml
  def index
    @channel_on_demands = ChannelOnDemand.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @channel_on_demands }
    end
  end

  # GET /channel_on_demands/1
  # GET /channel_on_demands/1.xml
  def show
    @channel_on_demand = ChannelOnDemand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @channel_on_demand }
    end
  end

  # GET /channel_on_demands/new
  # GET /channel_on_demands/new.xml
  def new
    @channel_on_demand = ChannelOnDemand.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @channel_on_demand }
    end
  end

  # GET /channel_on_demands/1/edit
  def edit
    @channel_on_demand = ChannelOnDemand.find(params[:id])
  end

  # POST /channel_on_demands
  # POST /channel_on_demands.xml
  def create
    @channel_on_demand = ChannelOnDemand.new(params[:channel_on_demand])

    respond_to do |format|
      if @channel_on_demand.save
        flash[:notice] = 'ChannelOnDemand was successfully created.'
        format.html { redirect_to(@channel_on_demand) }
        format.xml  { render :xml => @channel_on_demand, :status => :created, :location => @channel_on_demand }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @channel_on_demand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /channel_on_demands/1
  # PUT /channel_on_demands/1.xml
  def update
    @channel_on_demand = ChannelOnDemand.find(params[:id])

    respond_to do |format|
      if @channel_on_demand.update_attributes(params[:channel_on_demand])
        flash[:notice] = 'ChannelOnDemand was successfully updated.'
        format.html { redirect_to(@channel_on_demand) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @channel_on_demand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_on_demands/1
  # DELETE /channel_on_demands/1.xml
  def destroy
    @channel_on_demand = ChannelOnDemand.find(params[:id])
    @channel_on_demand.destroy

    respond_to do |format|
      format.html { redirect_to(channel_on_demands_url) }
      format.xml  { head :ok }
    end
  end
end
