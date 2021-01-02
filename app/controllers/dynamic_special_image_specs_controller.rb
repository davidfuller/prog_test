class DynamicSpecialImageSpecsController < ApplicationController
  # GET /dynamic_special_image_specs
  # GET /dynamic_special_image_specs.xml
  def index
    @dynamic_special_image_specs = DynamicSpecialImageSpec.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dynamic_special_image_specs }
    end
  end

  # GET /dynamic_special_image_specs/1
  # GET /dynamic_special_image_specs/1.xml
  def show
    @dynamic_special_image_spec = DynamicSpecialImageSpec.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dynamic_special_image_spec }
    end
  end

  # GET /dynamic_special_image_specs/new
  # GET /dynamic_special_image_specs/new.xml
  def new
    @dynamic_special_image_spec = DynamicSpecialImageSpec.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dynamic_special_image_spec }
    end
  end

  # GET /dynamic_special_image_specs/1/edit
  def edit
    @dynamic_special_image_spec = DynamicSpecialImageSpec.find(params[:id])
  end

  # POST /dynamic_special_image_specs
  # POST /dynamic_special_image_specs.xml
  def create
    @dynamic_special_image_spec = DynamicSpecialImageSpec.new(params[:dynamic_special_image_spec])

    respond_to do |format|
      if @dynamic_special_image_spec.save
        flash[:notice] = 'Image Specifiction was successfully created.'
        format.html { redirect_to(dynamic_special_image_specs_path) }
        format.xml  { render :xml => @dynamic_special_image_spec, :status => :created, :location => @dynamic_special_image_spec }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dynamic_special_image_spec.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dynamic_special_image_specs/1
  # PUT /dynamic_special_image_specs/1.xml
  def update
    @dynamic_special_image_spec = DynamicSpecialImageSpec.find(params[:id])

    respond_to do |format|
      if @dynamic_special_image_spec.update_attributes(params[:dynamic_special_image_spec])
        flash[:notice] = 'Image Specifiction was successfully updated.'
        format.html { redirect_to(dynamic_special_image_specs_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dynamic_special_image_spec.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dynamic_special_image_specs/1
  # DELETE /dynamic_special_image_specs/1.xml
  def destroy
    @dynamic_special_image_spec = DynamicSpecialImageSpec.find(params[:id])
    @dynamic_special_image_spec.destroy

    respond_to do |format|
      format.html { redirect_to(dynamic_special_image_specs_url) }
      format.xml  { head :ok }
    end
  end
end
