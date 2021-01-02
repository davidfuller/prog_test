class SpecialFieldsController < ApplicationController
  # GET /special_fields
  # GET /special_fields.xml
  def index
    @special_fields = SpecialField.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @special_fields }
    end
  end

  # GET /special_fields/1
  # GET /special_fields/1.xml
  def show
    @special_field = SpecialField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @special_field }
    end
  end

  # GET /special_fields/new
  # GET /special_fields/new.xml
  def new
    @special_field = SpecialField.new
    @special_field.dynamic_special_id = params[:dynamic_special_id]
    @special_field.source = params[:source]
    @special_field.number = params[:number]||1

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @special_field }
    end
  end

  # GET /special_fields/1/edit
  def edit
    @special_field = SpecialField.find(params[:id])
    @special_field.source = params[:source]
  end

  # POST /special_fields
  # POST /special_fields.xml
  def create
    @special_field = SpecialField.new(params[:special_field])

    respond_to do |format|
      if @special_field.save
        flash[:notice] = 'Special Field was successfully created.'
        if @special_field.source == 'dynamic'
          format.html { redirect_to(dynamic_special_path(@special_field.dynamic_special_id)) }
          format.xml  { head :ok }
        else
          format.html { redirect_to(@special_field) }
          format.xml  { render :xml => @special_field, :status => :created, :location => @special_field }
         end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @special_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /special_fields/1
  # PUT /special_fields/1.xml
  def update
    @special_field = SpecialField.find(params[:id])

    respond_to do |format|
      if @special_field.update_attributes(params[:special_field])
        flash[:notice] = 'Special Field was successfully updated.'
        if @special_field.source == 'dynamic'
          format.html { redirect_to(dynamic_special_path(@special_field.dynamic_special_id)) }
          format.xml  { head :ok }
        else
          format.html { redirect_to(@special_field) }
          format.xml  { head :ok }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @special_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /special_fields/1
  # DELETE /special_fields/1.xml
  def destroy
    @special_field = SpecialField.find(params[:id])
    @special_field.destroy

    respond_to do |format|
      if params[:source] == 'dynamic'
        format.html { redirect_to(dynamic_special_path(@special_field.dynamic_special_id)) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(special_fields_url) }
        format.xml  { head :ok }
      end
    end
  end
end
