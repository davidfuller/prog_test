class DynamicSpecialTemplatesController < ApplicationController
  # GET /dynamic_special_templates
  # GET /dynamic_special_templates.xml
  def index
    @dynamic_special_templates = DynamicSpecialTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dynamic_special_templates }
    end
  end

  # GET /dynamic_special_templates/1
  # GET /dynamic_special_templates/1.xml
  def show
    @dynamic_special_template = DynamicSpecialTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dynamic_special_template }
    end
  end

  # GET /dynamic_special_templates/new
  # GET /dynamic_special_templates/new.xml
  def new
    @dynamic_special_template = DynamicSpecialTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dynamic_special_template }
    end
  end

  # GET /dynamic_special_templates/1/edit
  def edit
    @dynamic_special_template = DynamicSpecialTemplate.find(params[:id])
  end

  # POST /dynamic_special_templates
  # POST /dynamic_special_templates.xml
  def create
    @dynamic_special_template = DynamicSpecialTemplate.new(params[:dynamic_special_template])

    respond_to do |format|
      if @dynamic_special_template.save
        flash[:notice] = 'Template was successfully created.'
        format.html { redirect_to(dynamic_special_templates_path) }
        format.xml  { render :xml => @dynamic_special_template, :status => :created, :location => @dynamic_special_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dynamic_special_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dynamic_special_templates/1
  # PUT /dynamic_special_templates/1.xml
  def update
    @dynamic_special_template = DynamicSpecialTemplate.find(params[:id])

    respond_to do |format|
      if @dynamic_special_template.update_attributes(params[:dynamic_special_template])
        flash[:notice] = 'Template was successfully updated.'
        format.html { redirect_to(dynamic_special_templates_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dynamic_special_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dynamic_special_templates/1
  # DELETE /dynamic_special_templates/1.xml
  def destroy
    @dynamic_special_template = DynamicSpecialTemplate.find(params[:id])
    @dynamic_special_template.destroy

    respond_to do |format|
      format.html { redirect_to(dynamic_special_templates_url) }
      format.xml  { head :ok }
    end
  end
end
