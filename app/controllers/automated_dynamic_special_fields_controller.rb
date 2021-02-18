class AutomatedDynamicSpecialFieldsController < ApplicationController
  # GET /automated_dynamic_special_fields
  # GET /automated_dynamic_special_fields.xml
  def index
    @automated_dynamic_special_fields = AutomatedDynamicSpecialField.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @automated_dynamic_special_fields }
    end
  end

  # GET /automated_dynamic_special_fields/1
  # GET /automated_dynamic_special_fields/1.xml
  def show
    @automated_dynamic_special_field = AutomatedDynamicSpecialField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @automated_dynamic_special_field }
    end
  end

  # GET /automated_dynamic_special_fields/new
  # GET /automated_dynamic_special_fields/new.xml
  def new
    @automated_dynamic_special_field = AutomatedDynamicSpecialField.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @automated_dynamic_special_field }
    end
  end

  # GET /automated_dynamic_special_fields/1/edit
  def edit
    @automated_dynamic_special_field = AutomatedDynamicSpecialField.find(params[:id])
  end

  # POST /automated_dynamic_special_fields
  # POST /automated_dynamic_special_fields.xml
  def create
    @automated_dynamic_special_field = AutomatedDynamicSpecialField.new(params[:automated_dynamic_special_field])

    respond_to do |format|
      if @automated_dynamic_special_field.save
        flash[:notice] = 'AutomatedDynamicSpecialField was successfully created.'
        format.html { redirect_to(@automated_dynamic_special_field) }
        format.xml  { render :xml => @automated_dynamic_special_field, :status => :created, :location => @automated_dynamic_special_field }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @automated_dynamic_special_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /automated_dynamic_special_fields/1
  # PUT /automated_dynamic_special_fields/1.xml
  def update
    @automated_dynamic_special_field = AutomatedDynamicSpecialField.find(params[:id])
    source = params[:automated_dynamic_special]
    respond_to do |format|
      if @automated_dynamic_special_field.update_attributes(params[:automated_dynamic_special_field])
        @automated_dynamic_special_field.reconcile_the_change()
        flash[:notice] = 'Field was successfully updated.'
        format.html { 
          if source
            @index_params = clean_params(params[:index_params])
            redirect_to automated_dynamic_special_path(source, :index_params => @index_params, :field_id => params[:id], :next_field_id => params[:automated_dynamic_special_field][:next_field_id], :edit_field => params[:edit_field])
          else
            redirect_to(automated_dynamic_special_fields_path) 
          end
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @automated_dynamic_special_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /automated_dynamic_special_fields/1
  # DELETE /automated_dynamic_special_fields/1.xml
  def destroy
    @automated_dynamic_special_field = AutomatedDynamicSpecialField.find(params[:id])
    @automated_dynamic_special_field.destroy

    respond_to do |format|
      format.html { redirect_to(automated_dynamic_special_fields_url) }
      format.xml  { head :ok }
    end
  end

  def clean_params(params)
    # Delete any blank params
    if params 
      params.delete_if {|k,v| v.blank?}
    end
  end

end
