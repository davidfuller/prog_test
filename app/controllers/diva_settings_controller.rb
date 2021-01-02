class DivaSettingsController < ApplicationController
  # GET /diva_settings
  # GET /diva_settings.xml
  def index
    @diva_settings = DivaSetting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @diva_settings }
    end
  end

  # GET /diva_settings/1
  # GET /diva_settings/1.xml
  def show
    @diva_setting = DivaSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @diva_setting }
    end
  end

  # GET /diva_settings/new
  # GET /diva_settings/new.xml
  def new
    @diva_setting = DivaSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @diva_setting }
    end
  end

  # GET /diva_settings/1/edit
  def edit
    @diva_setting = DivaSetting.find(params[:id])
  end

  # POST /diva_settings
  # POST /diva_settings.xml
  def create
    @diva_setting = DivaSetting.new(params[:diva_setting])

    respond_to do |format|
      if @diva_setting.save
        flash[:notice] = 'Diva Setting was successfully created.'
        format.html { redirect_to(diva_settings_path) }
        format.xml  { render :xml => @diva_setting, :status => :created, :location => @diva_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @diva_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /diva_settings/1
  # PUT /diva_settings/1.xml
  def update
    @diva_setting = DivaSetting.find(params[:id])

    respond_to do |format|
      if @diva_setting.update_attributes(params[:diva_setting])
        flash[:notice] = 'Diva Setting was successfully updated.'
        format.html { redirect_to(diva_settings_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @diva_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /diva_settings/1
  # DELETE /diva_settings/1.xml
  def destroy
    @diva_setting = DivaSetting.find(params[:id])
    @diva_setting.destroy

    respond_to do |format|
      format.html { redirect_to(diva_settings_url) }
      format.xml  { head :ok }
    end
  end
end
