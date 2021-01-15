class AutomatedDynamicSpecialsController < ApplicationController
  # GET /automated_dynamic_specials
  # GET /automated_dynamic_specials.xml
  def index
    @automated_dynamic_specials = AutomatedDynamicSpecial.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @automated_dynamic_specials }
    end
  end

  # GET /automated_dynamic_specials/1
  # GET /automated_dynamic_specials/1.xml
  def show
    @automated_dynamic_special = AutomatedDynamicSpecial.find(params[:id])
    @logo_sets = @automated_dynamic_special.logos
    @promo_field = @automated_dynamic_special.promo_field
    @promo_dynamic_special_media = @automated_dynamic_special.promo_dynamic_special_media(@promo_field)
    params[:image_type] = @promo_field.field_type_name
    @dynamic_special_medias = DynamicSpecialMedia.search(params)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @automated_dynamic_special }
      format.js 
    end
  end

  # GET /automated_dynamic_specials/new
  # GET /automated_dynamic_specials/new.xml
  def new
    @automated_dynamic_special = AutomatedDynamicSpecial.new
    @automated_dynamic_special.fix_nil_last_use
    @channels = Channel.all
    @templates = DynamicSpecialTemplate.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @automated_dynamic_special }
    end
  end

  # GET /automated_dynamic_specials/1/edit
  def edit
    @channels = Channel.all
    @templates = DynamicSpecialTemplate.all
    @automated_dynamic_special = AutomatedDynamicSpecial.find(params[:id])
  end

  # POST /automated_dynamic_specials
  # POST /automated_dynamic_specials.xml
  def create
    @automated_dynamic_special = AutomatedDynamicSpecial.new(params[:automated_dynamic_special])
    @automated_dynamic_special.create_fields

    respond_to do |format|
      if @automated_dynamic_special.save
        flash[:notice] = 'Automated Dynamic Special was successfully created.'
        format.html { redirect_to(@automated_dynamic_special) }
        format.xml  { render :xml => @automated_dynamic_special, :status => :created, :location => @automated_dynamic_special }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @automated_dynamic_special.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /automated_dynamic_specials/1
  # PUT /automated_dynamic_specials/1.xml
  def update
    @automated_dynamic_special = AutomatedDynamicSpecial.find(params[:id])

    respond_to do |format|
      if @automated_dynamic_special.update_attributes(params[:automated_dynamic_special])
        flash[:notice] = 'AutomatedDynamicSpecial was successfully updated.'
        format.html { redirect_to(@automated_dynamic_special) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @automated_dynamic_special.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /automated_dynamic_specials/1
  # DELETE /automated_dynamic_specials/1.xml
  def destroy
    @automated_dynamic_special = AutomatedDynamicSpecial.find(params[:id])
    @automated_dynamic_special.destroy

    respond_to do |format|
      format.html { redirect_to(automated_dynamic_specials_url) }
      format.xml  { head :ok }
    end
  end

  def use_media
    field = AutomatedDynamicSpecialField.find(params[:field_id])
    if field && params[:dynamic_special_media_id]
      field.the_id = params[:dynamic_special_media_id]
      if field.save
        field.reconcile_the_change()
        flash[:notice] = 'Media File successfully updated'
      else
        flash[:notice] = 'Issue with updating media file'
      end
    else
      flash[:notice] = 'Issue with updating media file'
    end
    redirect_to automated_dynamic_special_path({:id => params[:id], :search => params[:search], :page => params[:page]})
  end
end
