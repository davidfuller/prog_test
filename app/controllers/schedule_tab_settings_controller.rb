class ScheduleTabSettingsController < ApplicationController
  # GET /schedule_tab_settings
  # GET /schedule_tab_settings.xml
  def index
    @schedule_tab_settings = ScheduleTabSetting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedule_tab_settings }
    end
  end

  # GET /schedule_tab_settings/1
  # GET /schedule_tab_settings/1.xml
  def show
    @schedule_tab_setting = ScheduleTabSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule_tab_setting }
    end
  end

  # GET /schedule_tab_settings/new
  # GET /schedule_tab_settings/new.xml
  def new
    @schedule_tab_setting = ScheduleTabSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @schedule_tab_setting }
    end
  end

  # GET /schedule_tab_settings/1/edit
  def edit
    @schedule_tab_setting = ScheduleTabSetting.find(params[:id])
  end

  # POST /schedule_tab_settings
  # POST /schedule_tab_settings.xml
  def create
    @schedule_tab_setting = ScheduleTabSetting.new(params[:schedule_tab_setting])

    respond_to do |format|
      if @schedule_tab_setting.save
        flash[:notice] = 'Tab was successfully created.'
        format.html { redirect_to(schedule_tab_settings_path) }
        format.xml  { render :xml => @schedule_tab_setting, :status => :created, :location => @schedule_tab_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @schedule_tab_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schedule_tab_settings/1
  # PUT /schedule_tab_settings/1.xml
  def update
    @schedule_tab_setting = ScheduleTabSetting.find(params[:id])

    respond_to do |format|
      if @schedule_tab_setting.update_attributes(params[:schedule_tab_setting])
        flash[:notice] = 'Tab was successfully updated.'
        format.html { redirect_to(schedule_tab_settings_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @schedule_tab_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schedule_tab_settings/1
  # DELETE /schedule_tab_settings/1.xml
  def destroy
    @schedule_tab_setting = ScheduleTabSetting.find(params[:id])
    @schedule_tab_setting.destroy

    respond_to do |format|
      format.html { redirect_to(schedule_tab_settings_url) }
      format.xml  { head :ok }
    end
  end
end
