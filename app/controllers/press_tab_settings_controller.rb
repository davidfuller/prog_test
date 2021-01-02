class PressTabSettingsController < ApplicationController
  # GET /press_tab_settings
  # GET /press_tab_settings.xml
  def index
    @press_tab_settings = PressTabSetting.sorted_tabs

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @press_tab_settings }
    end
  end

  # GET /press_tab_settings/1
  # GET /press_tab_settings/1.xml
  def show
    @press_tab_setting = PressTabSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @press_tab_setting }
    end
  end

  # GET /press_tab_settings/new
  # GET /press_tab_settings/new.xml
  def new
    @press_tab_setting = PressTabSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @press_tab_setting }
    end
  end

  # GET /press_tab_settings/1/edit
  def edit
    @press_tab_setting = PressTabSetting.find(params[:id])
  end

  # POST /press_tab_settings
  # POST /press_tab_settings.xml
  def create
    @press_tab_setting = PressTabSetting.new(params[:press_tab_setting])

    respond_to do |format|
      if @press_tab_setting.save
        flash[:notice] = 'PressTabSetting was successfully created.'
        format.html { redirect_to(press_tab_settings_url) }
        format.xml  { render :xml => @press_tab_setting, :status => :created, :location => @press_tab_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @press_tab_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /press_tab_settings/1
  # PUT /press_tab_settings/1.xml
  def update
    @press_tab_setting = PressTabSetting.find(params[:id])

    respond_to do |format|
      if @press_tab_setting.update_attributes(params[:press_tab_setting])
        flash[:notice] = 'PressTabSetting was successfully updated.'
        format.html { redirect_to(press_tab_settings_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @press_tab_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /press_tab_settings/1
  # DELETE /press_tab_settings/1.xml
  def destroy
    @press_tab_setting = PressTabSetting.find(params[:id])
    @press_tab_setting.destroy

    respond_to do |format|
      format.html { redirect_to(press_tab_settings_url) }
      format.xml  { head :ok }
    end
  end
end
