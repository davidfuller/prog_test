class TrailerTabSettingsController < ApplicationController
  # GET /trailer_tab_settings
  # GET /trailer_tab_settings.xml
  def index
    @trailer_tab_settings = TrailerTabSetting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trailer_tab_settings }
    end
  end

  # GET /trailer_tab_settings/1
  # GET /trailer_tab_settings/1.xml
  def show
    @trailer_tab_setting = TrailerTabSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trailer_tab_setting }
    end
  end

  # GET /trailer_tab_settings/new
  # GET /trailer_tab_settings/new.xml
  def new
    @trailer_tab_setting = TrailerTabSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trailer_tab_setting }
    end
  end

  # GET /trailer_tab_settings/1/edit
  def edit
    @trailer_tab_setting = TrailerTabSetting.find(params[:id])
  end

  # POST /trailer_tab_settings
  # POST /trailer_tab_settings.xml
  def create
    @trailer_tab_setting = TrailerTabSetting.new(params[:trailer_tab_setting])

    respond_to do |format|
      if @trailer_tab_setting.save
        flash[:notice] = 'Trailer tab was successfully created.'
        format.html { redirect_to(trailer_tab_settings_url) }
        format.xml  { render :xml => @trailer_tab_setting, :status => :created, :location => @trailer_tab_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trailer_tab_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trailer_tab_settings/1
  # PUT /trailer_tab_settings/1.xml
  def update
    @trailer_tab_setting = TrailerTabSetting.find(params[:id])

    respond_to do |format|
      if @trailer_tab_setting.update_attributes(params[:trailer_tab_setting])
        flash[:notice] = 'Trailer tab was successfully updated.'
        format.html { redirect_to(trailer_tab_settings_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trailer_tab_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trailer_tab_settings/1
  # DELETE /trailer_tab_settings/1.xml
  def destroy
    @trailer_tab_setting = TrailerTabSetting.find(params[:id])
    @trailer_tab_setting.destroy

    respond_to do |format|
      format.html { redirect_to(trailer_tab_settings_url) }
      format.xml  { head :ok }
    end
  end
end
