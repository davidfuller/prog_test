class DynamicSpecialFieldsController < ApplicationController
  # GET /dynamic_special_fields
  # GET /dynamic_special_fields.xml
  def index
    @dynamic_special_fields = DynamicSpecialField.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dynamic_special_fields }
    end
  end

  # GET /dynamic_special_fields/1
  # GET /dynamic_special_fields/1.xml
  def show
    @dynamic_special_field = DynamicSpecialField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dynamic_special_field }
    end
  end

  # GET /dynamic_special_fields/new
  # GET /dynamic_special_fields/new.xml
  def new
    @dynamic_special_field = DynamicSpecialField.new
    @special_types = DynamicSpecialImageSpec.all(:order => :name)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dynamic_special_field }
    end
  end

  # GET /dynamic_special_fields/1/edit
  def edit
    @dynamic_special_field = DynamicSpecialField.find(params[:id])
    @special_types = DynamicSpecialImageSpec.all(:order => :name)
  end

  # POST /dynamic_special_fields
  # POST /dynamic_special_fields.xml
  def create
    @dynamic_special_field = DynamicSpecialField.new(params[:dynamic_special_field])

    respond_to do |format|
      if @dynamic_special_field.save
        flash[:notice] = 'Dynamic Special Field was successfully created.'
        format.html { redirect_to(dynamic_special_fields_path) }
        format.xml  { render :xml => @dynamic_special_field, :status => :created, :location => @dynamic_special_field }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dynamic_special_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dynamic_special_fields/1
  # PUT /dynamic_special_fields/1.xml
  def update
    @dynamic_special_field = DynamicSpecialField.find(params[:id])

    respond_to do |format|
      if @dynamic_special_field.update_attributes(params[:dynamic_special_field])
        flash[:notice] = 'Dynamic Special Field was successfully updated.'
        format.html { redirect_to(dynamic_special_fields_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dynamic_special_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dynamic_special_fields/1
  # DELETE /dynamic_special_fields/1.xml
  def destroy
    @dynamic_special_field = DynamicSpecialField.find(params[:id])
    @dynamic_special_field.destroy

    respond_to do |format|
      format.html { redirect_to(dynamic_special_fields_url) }
      format.xml  { head :ok }
    end
  end
end
