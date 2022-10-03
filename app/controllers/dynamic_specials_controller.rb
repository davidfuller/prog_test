class DynamicSpecialsController < ApplicationController
  # GET /dynamic_specials
  # GET /dynamic_specials.xml
  def index
    @show_new_edit = Date.today <= Date.new(2021,4,1)
    remove_v4 = true
    respond_to do |format|
      format.html { @dynamic_specials = DynamicSpecial.search(params[:search],params[:channel], params[:page], params[:show_duplicates], params[:show_all], params[:show_only])
                    @channel_display = Channel.display(remove_v4)
                    @show_duplicates = params[:show_duplicates]}
      format.xml  { @dynamic_specials = DynamicSpecial.xml_data(params[:channel]) }
    end
  end

  # GET /dynamic_specials/1
  # GET /dynamic_specials/1.xml
  def show
    @dynamic_special = DynamicSpecial.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dynamic_special }
    end
  end

  # GET /dynamic_specials/new
  # GET /dynamic_specials/new.xml
  def new
    @dynamic_special = DynamicSpecial.new
    @dynamic_special.fix_nil_last_use
    @channels = Channel.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dynamic_special }
    end
  end

  # GET /dynamic_specials/1/edit
  def edit
    @dynamic_special = DynamicSpecial.find(params[:id])
    @dynamic_special.fix_nil_last_use
    @channels = Channel.all
  end

  # POST /dynamic_specials
  # POST /dynamic_specials.xml
  def create
    @dynamic_special = DynamicSpecial.new(params[:dynamic_special])
    @channels = Channel.all

    respond_to do |format|
      if @dynamic_special.save
        flash[:notice] = 'Dynamic Special Page was successfully created. Add fields if you wish.'
        format.html { redirect_to @dynamic_special }
        format.xml  { render :xml => @dynamic_special, :status => :created, :location => @dynamic_special }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dynamic_special.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dynamic_specials/1
  # PUT /dynamic_specials/1.xml
  def update
    @dynamic_special = DynamicSpecial.find(params[:id])
    @channels = Channel.all    

    respond_to do |format|
      if @dynamic_special.update_attributes(params[:dynamic_special])
        flash[:notice] = 'Dynamic Special was successfully updated.'
        format.html { redirect_to @dynamic_special } #dynamic_specials_path(:channel => session[:special_channel]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dynamic_special.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dynamic_specials/1
  # DELETE /dynamic_specials/1.xml
  def destroy
    @dynamic_special = DynamicSpecial.find(params[:id])
    channel = @dynamic_special.channel_name
    @dynamic_special.destroy

    respond_to do |format|
      format.html { redirect_to dynamic_specials_url(:channel => session[:special_channel], :show_all => session[:special_show_all], 
                                                      :show_only => session[:special_show_only],
                                                      :show_duplicates => session[:special_show_duplicates]) }
      format.xml  { head :ok }
    end
  end
  
  def duplicate
    original = DynamicSpecial.find(params[:id])
    @dynamic_special = original.clone
    @dynamic_special.save
    @dynamic_special.add_special_fields(original)
    @channels = Channel.all

    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml  { render :xml => @dynamic_special }
    end
  end

  def delete_multiple
    ids_to_delete = params[:dynamic_special_ids]
    if ids_to_delete && ids_to_delete.count > 0
      deleted_ids = DynamicSpecial.destroy(ids_to_delete)
      flash[:notice] = my_pluralise('special', deleted_ids.length) + ' deleted'
    else
      flash[:notice] = 'Nothing deleted'
    end 
    redirect_to dynamic_specials_url(:channel => session[:special_channel], :show_all => session[:special_show_all], :show_only => session[:special_show_only],
                                      :show_duplicates => session[:special_show_duplicates])
  end

  def my_pluralise(text, number)
    if number == 1
      return number.to_s + ' ' + text
    else
      return number.to_s + ' ' + text.pluralize()
    end
  end
end
