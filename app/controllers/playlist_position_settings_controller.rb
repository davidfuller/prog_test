class PlaylistPositionSettingsController < ApplicationController
  # GET /playlist_position_settings
  # GET /playlist_position_settings.xml
  def index
    @playlist_position_settings = PlaylistPositionSetting.sorted_position

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @playlist_position_settings }
    end
  end

  # GET /playlist_position_settings/1
  # GET /playlist_position_settings/1.xml
  def show
    @playlist_position_setting = PlaylistPositionSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @playlist_position_setting }
    end
  end

  # GET /playlist_position_settings/new
  # GET /playlist_position_settings/new.xml
  def new
    @playlist_position_setting = PlaylistPositionSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @playlist_position_setting }
    end
  end

  # GET /playlist_position_settings/1/edit
  def edit
    @playlist_position_setting = PlaylistPositionSetting.find(params[:id])
  end

  # POST /playlist_position_settings
  # POST /playlist_position_settings.xml
  def create
    @playlist_position_setting = PlaylistPositionSetting.new(params[:playlist_position_setting])

    respond_to do |format|
      if @playlist_position_setting.save
        flash[:notice] = 'PlaylistPositionSetting was successfully created.'
        format.html { redirect_to(playlist_position_settings_url) }
        format.xml  { render :xml => @playlist_position_setting, :status => :created, :location => @playlist_position_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @playlist_position_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /playlist_position_settings/1
  # PUT /playlist_position_settings/1.xml
  def update
    @playlist_position_setting = PlaylistPositionSetting.find(params[:id])

    respond_to do |format|
      if @playlist_position_setting.update_attributes(params[:playlist_position_setting])
        flash[:notice] = 'PlaylistPositionSetting was successfully updated.'
        format.html { redirect_to(playlist_position_settings_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @playlist_position_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /playlist_position_settings/1
  # DELETE /playlist_position_settings/1.xml
  def destroy
    @playlist_position_setting = PlaylistPositionSetting.find(params[:id])
    @playlist_position_setting.destroy

    respond_to do |format|
      format.html { redirect_to(playlist_position_settings_url) }
      format.xml  { head :ok }
    end
  end
end
