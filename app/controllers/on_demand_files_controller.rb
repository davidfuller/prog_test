class OnDemandFilesController < ApplicationController
  # GET /on_demand_files
  # GET /on_demand_files.xml
  def index
    @on_demand_files = OnDemandFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @on_demand_files }
    end
  end

  # GET /on_demand_files/1
  # GET /on_demand_files/1.xml
  def show
    @on_demand_file = OnDemandFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @on_demand_file }
    end
  end

  # GET /on_demand_files/new
  # GET /on_demand_files/new.xml
  def new
    @on_demand_file = OnDemandFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @on_demand_file }
    end
  end

  # GET /on_demand_files/1/edit
  def edit
    @on_demand_file = OnDemandFile.find(params[:id])
  end

  # POST /on_demand_files
  # POST /on_demand_files.xml
  def create
    @on_demand_file = OnDemandFile.new(params[:on_demand_file])

    respond_to do |format|
      if @on_demand_file.save
        flash[:notice] = 'The On Demand File was successfully created.'
        format.html { redirect_to(on_demand_files_path) }
        format.xml  { render :xml => @on_demand_file, :status => :created, :location => @on_demand_file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @on_demand_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /on_demand_files/1
  # PUT /on_demand_files/1.xml
  def update
    @on_demand_file = OnDemandFile.find(params[:id])

    respond_to do |format|
      if @on_demand_file.update_attributes(params[:on_demand_file])
        flash[:notice] = 'The On Demand File was successfully updated.'
        format.html { redirect_to(on_demand_files_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @on_demand_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /on_demand_files/1
  # DELETE /on_demand_files/1.xml
  def destroy
    @on_demand_file = OnDemandFile.find(params[:id])
    @on_demand_file.destroy

    respond_to do |format|
      format.html { redirect_to(on_demand_files_url) }
      format.xml  { head :ok }
    end
  end
end
