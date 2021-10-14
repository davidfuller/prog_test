class AutomatedDynamicSpecialsController < ApplicationController
  # GET /automated_dynamic_specials
  # GET /automated_dynamic_specials.xml
  def index
    respond_to do |format|
      format.html do
        @automated_dynamic_specials = AutomatedDynamicSpecial.search(params)
        @channel_display = Channel.display
        @templates = DynamicSpecialTemplate.template_display_with_all
      end# index.html.erb
      format.xml  { @automated_dynamic_specials = AutomatedDynamicSpecial.xml_data(params[:channel]) }
    end
  end

  def report
    if params[:start_date].blank?
      params[:start_date] = AutomatedDynamicSpecial.default_report_dates[:start_date]
    end
    if params[:end_date].blank?
      params[:end_date] = AutomatedDynamicSpecial.default_report_dates[:end_date]
    end

    @automated_dynamic_specials = AutomatedDynamicSpecial.report_search(params)
    @channel_display = Channel.display
    @templates = DynamicSpecialTemplate.template_display_with_all
  end

  # GET /automated_dynamic_specials/1
  # GET /automated_dynamic_specials/1.xml
  def show
    @automated_dynamic_special = AutomatedDynamicSpecial.find(params[:id])
    @logo_sets = @automated_dynamic_special.logos
    @promo_field = @automated_dynamic_special.promo_field
    @promo_dynamic_special_media = @automated_dynamic_special.promo_dynamic_special_media(@promo_field)
    if @promo_field
      params[:image_type] = @promo_field.field_type_name
    end
    @dynamic_special_medias = DynamicSpecialMedia.search(params)
    @index_params = clean_params(params[:index_params])
    if params[:field_id]
      @field_index = @automated_dynamic_special.next_editable_field_id(params[:field_id].to_i, params[:next_field_id])
    else
      @field_index = @automated_dynamic_special.next_editable_field_id(0, params[:next_field_id])
    end
    @edit_field = params[:edit_field]||false
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @automated_dynamic_special }
      format.js 
    end
  end

  def export
    automated_dynamic_special = AutomatedDynamicSpecial.find(params[:id])
    data = automated_dynamic_special.data_for_preview
    my_data = AutomatedDynamicSpecial.to_csv(data)
    respond_to do |format|
      format.csv 	{send_data my_data, :filename => "Field_Data-#{Time.current.to_s(:broadcast_filename_datetime)}.csv"}
    end
  end

  # GET /automated_dynamic_specials/new
  # GET /automated_dynamic_specials/new.xml
  def new
    @automated_dynamic_special = AutomatedDynamicSpecial.new
    @automated_dynamic_special.fix_nil_last_use
    @channels = Channel.all
    @templates = DynamicSpecialTemplate.all
    @index_params = clean_params(params[:index_params])

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
    @index_params = clean_params(params[:index_params])
  end

  # POST /automated_dynamic_specials
  # POST /automated_dynamic_specials.xml
  def create
    @automated_dynamic_special = AutomatedDynamicSpecial.new(params[:automated_dynamic_special])
    @index_params = clean_params(params[:index_params])
    respond_to do |format|
      if @automated_dynamic_special.save
        @automated_dynamic_special.create_fields
        if @automated_dynamic_special.save
          flash[:notice] = 'Automated Dynamic Special was successfully created.'
          format.html {redirect_to automated_dynamic_special_path(@automated_dynamic_special, :index_params => @index_params) }
          format.xml  { render :xml => @automated_dynamic_special, :status => :created, :location => @automated_dynamic_special }
        else
          format.html do
            @channels = Channel.all
            @templates = DynamicSpecialTemplate.all
            render :action => "new" 
          end 
          format.xml  { render :xml => @automated_dynamic_special.errors, :status => :unprocessable_entity }
        end
      else
        format.html do
          @channels = Channel.all
          @templates = DynamicSpecialTemplate.all
          render :action => "new"
        end 
        format.xml  { render :xml => @automated_dynamic_special.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /automated_dynamic_specials/1
  # PUT /automated_dynamic_specials/1.xml
  def update
    @automated_dynamic_special = AutomatedDynamicSpecial.find(params[:id])
    @index_params = clean_params(params[:index_params])

    respond_to do |format|
      if @automated_dynamic_special.update_attributes(params[:automated_dynamic_special])
        flash[:notice] = 'Automated Dynamic Special was successfully updated.'
        format.html { redirect_to automated_dynamic_special_path(@automated_dynamic_special, :index_params => @index_params) }
        format.xml  { head :ok }
      else
        format.html do 
          @channels = Channel.all
          @templates = DynamicSpecialTemplate.all
          render :action => "edit" 
        end
        format.xml  { render :xml => @automated_dynamic_special.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /automated_dynamic_specials/1
  # DELETE /automated_dynamic_specials/1.xml
  def destroy
    @automated_dynamic_special = AutomatedDynamicSpecial.find(params[:id])
    @automated_dynamic_special.destroy
    @index_params = clean_params(params[:index_params])

    respond_to do |format|
      format.html { redirect_to automated_dynamic_specials_url(@index_params)}
      format.xml  { head :ok }
    end
  end

  def archive
    @automated_dynamic_special = AutomatedDynamicSpecial.find(params[:id])
    @automated_dynamic_special.archive = true
    @automated_dynamic_special.save
    flash[:notice] = 'Dynamic Special archived'
    @index_params = clean_params(params[:index_params])

    respond_to do |format|
      format.html { redirect_to automated_dynamic_specials_url(@index_params)}
      format.xml  { head :ok }
    end
  end



  def use_media
    field = AutomatedDynamicSpecialField.find(params[:field_id])
    @index_params = clean_params(params[:index_params])
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
    redirect_to automated_dynamic_special_path({:id => params[:id], :search => params[:search], :page => params[:page], :index_params => @index_params})
  end

  def duplicate
    original = AutomatedDynamicSpecial.find(params[:id])
    @automated_dynamic_special = original.clone
    @automated_dynamic_special.name = AutomatedDynamicSpecial.duplicate_name(original.name)
    @automated_dynamic_special.special_preview_id = nil
    @automated_dynamic_special.save
    @automated_dynamic_special.add_special_fields(original)
    @channels = Channel.all
    @templates = DynamicSpecialTemplate.all
    @index_params = clean_params(params[:index_params])
    flash[:notice] = "Duplicate Special created. You may want to change any details, then click Update"
  
    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml  { render :xml => @automated_dynamic_special }
    end
  end

  def demo_image
    @image_template = DynamicSpecialTemplate.find_by_id(params[:changed_template_id])
    respond_to do |format|
      format.js
    end
  end

  def clean_params(params)
    # Delete any blank params
    if params 
      params.delete_if {|k,v| v.blank?}
    end
  end

  def archive_multiple
    @index_params = clean_params(params[:index_params])
    ids_to_delete = params[:automated_dynamic_special_ids]
    archived_count = 0
    if ids_to_delete && ids_to_delete.count > 0
      records = AutomatedDynamicSpecial.find(ids_to_delete)
      records.each do |record|
        record.archive = true
        record.save
        archived_count += 1
      end
      flash[:notice] = my_pluralise('special', archived_count) + ' archived'
    else
      flash[:notice] = 'Nothing deleted'
    end 
    
    redirect_to automated_dynamic_specials_url(@index_params)
  end

  def my_pluralise(text, number)
    if number == 1
      return number.to_s + ' ' + text
    else
      return number.to_s + ' ' + text.pluralize()
    end
  end

end

