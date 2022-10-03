class SpecialScheduleSettingsController < ApplicationController
  # GET /special_schedule_settings
  # GET /special_schedule_settings.xml
  def index
    @special_schedule_settings = SpecialScheduleSetting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @special_schedule_settings }
    end
  end

  # GET /special_schedule_settings/1
  # GET /special_schedule_settings/1.xml
  def show
    @special_schedule_setting = SpecialScheduleSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @special_schedule_setting }
    end
  end

  # GET /special_schedule_settings/new
  # GET /special_schedule_settings/new.xml
  def new
    @special_schedule_setting = SpecialScheduleSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @special_schedule_setting }
    end
  end

  # GET /special_schedule_settings/1/edit
  def edit
    @special_schedule_setting = SpecialScheduleSetting.find(params[:id])
  end

  # POST /special_schedule_settings
  # POST /special_schedule_settings.xml
  def create
    @special_schedule_setting = SpecialScheduleSetting.new(params[:special_schedule_setting])

    respond_to do |format|
      if @special_schedule_setting.save
        flash[:notice] = 'SpecialScheduleSetting was successfully created.'
        format.html { redirect_to(@special_schedule_setting) }
        format.xml  { render :xml => @special_schedule_setting, :status => :created, :location => @special_schedule_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @special_schedule_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /special_schedule_settings/1
  # PUT /special_schedule_settings/1.xml
  def update
    @special_schedule_setting = SpecialScheduleSetting.find(params[:id])

    respond_to do |format|
      if @special_schedule_setting.update_attributes(params[:special_schedule_setting])
        flash[:notice] = 'SpecialScheduleSetting was successfully updated.'
        format.html { redirect_to(@special_schedule_setting) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @special_schedule_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /special_schedule_settings/1
  # DELETE /special_schedule_settings/1.xml
  def destroy
    @special_schedule_setting = SpecialScheduleSetting.find(params[:id])
    @special_schedule_setting.destroy

    respond_to do |format|
      format.html { redirect_to(special_schedule_settings_url) }
      format.xml  { head :ok }
    end
  end
end
