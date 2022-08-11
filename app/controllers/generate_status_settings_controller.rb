class GenerateStatusSettingsController < ApplicationController
  # GET /generate_status_settings
  # GET /generate_status_settings.xml
  def index
    @generate_status_settings = GenerateStatusSetting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @generate_status_settings }
    end
  end

  # GET /generate_status_settings/1
  # GET /generate_status_settings/1.xml
  def show
    @generate_status_setting = GenerateStatusSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @generate_status_setting }
    end
  end

  # GET /generate_status_settings/new
  # GET /generate_status_settings/new.xml
  def new
    @generate_status_setting = GenerateStatusSetting.new
    @channels = Channel.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @generate_status_setting }
    end
  end

  # GET /generate_status_settings/1/edit
  def edit
    @channels = Channel.all
    @generate_status_setting = GenerateStatusSetting.find(params[:id])
  end

  # POST /generate_status_settings
  # POST /generate_status_settings.xml
  def create
    @generate_status_setting = GenerateStatusSetting.new(params[:generate_status_setting])

    respond_to do |format|
      if @generate_status_setting.save
        flash[:notice] = 'Generate Status Setting was successfully created.'
        format.html { redirect_to generate_status_settings_path }
        format.xml  { render :xml => @generate_status_setting, :status => :created, :location => @generate_status_setting }
      else
        @channels = Channel.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @generate_status_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /generate_status_settings/1
  # PUT /generate_status_settings/1.xml
  def update
    @generate_status_setting = GenerateStatusSetting.find(params[:id])
    respond_to do |format|
      if @generate_status_setting.update_attributes(params[:generate_status_setting])
        flash[:notice] = 'Generate Status Setting was successfully updated.'
        format.html { redirect_to generate_status_settings_path }
        format.xml  { head :ok }
      else
        @channels = Channel.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @generate_status_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /generate_status_settings/1
  # DELETE /generate_status_settings/1.xml
  def destroy
    @generate_status_setting = GenerateStatusSetting.find(params[:id])
    @generate_status_setting.destroy

    respond_to do |format|
      format.html { redirect_to(generate_status_settings_url) }
      format.xml  { head :ok }
    end
  end
end
