class DynamicSpecialLogosController < ApplicationController
  # GET /dynamic_special_logos
  # GET /dynamic_special_logos.xml
  def index
    @dynamic_special_logos = DynamicSpecialLogo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dynamic_special_logos }
    end
  end

  # GET /dynamic_special_logos/1
  # GET /dynamic_special_logos/1.xml
  def show
    @dynamic_special_logo = DynamicSpecialLogo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dynamic_special_logo }
    end
  end

  # GET /dynamic_special_logos/new
  # GET /dynamic_special_logos/new.xml
  def new
    @dynamic_special_logo = DynamicSpecialLogo.new
    @special_types = DynamicSpecialImageSpec.all(:order => :name)
    @languages = Language.all(:order => :name)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dynamic_special_logo }
    end
  end

  # GET /dynamic_special_logos/1/edit
  def edit
    @special_types = DynamicSpecialImageSpec.all(:order => :name)
    @languages = Language.all(:order => :name)
    @dynamic_special_logo = DynamicSpecialLogo.find(params[:id])
  end

  # POST /dynamic_special_logos
  # POST /dynamic_special_logos.xml
  def create
    @dynamic_special_logo = DynamicSpecialLogo.new(params[:dynamic_special_logo])

    respond_to do |format|
      if @dynamic_special_logo.save
        flash[:notice] = 'Logo was successfully created.'
        format.html { redirect_to(dynamic_special_logos_path) }
        format.xml  { render :xml => @dynamic_special_logo, :status => :created, :location => @dynamic_special_logo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dynamic_special_logo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dynamic_special_logos/1
  # PUT /dynamic_special_logos/1.xml
  def update
    @dynamic_special_logo = DynamicSpecialLogo.find(params[:id])

    respond_to do |format|
      if @dynamic_special_logo.update_attributes(params[:dynamic_special_logo])
        flash[:notice] = 'Logo was successfully updated.'
        format.html { redirect_to(dynamic_special_logos_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dynamic_special_logo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dynamic_special_logos/1
  # DELETE /dynamic_special_logos/1.xml
  def destroy
    @dynamic_special_logo = DynamicSpecialLogo.find(params[:id])
    @dynamic_special_logo.destroy

    respond_to do |format|
      format.html { redirect_to(dynamic_special_logos_url) }
      format.xml  { head :ok }
    end
  end
end
