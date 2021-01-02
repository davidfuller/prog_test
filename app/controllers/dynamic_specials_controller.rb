class DynamicSpecialsController < ApplicationController
  # GET /dynamic_specials
  # GET /dynamic_specials.xml
  def index
    
    respond_to do |format|
      format.html { @dynamic_specials = DynamicSpecial.search(params[:search],params[:channel], params[:page], params[:show_duplicates], params[:show_all])
                    @channel_display = Channel.display
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
      format.html { redirect_to(dynamic_specials_url(:channel => session[:special_channel])) }
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
    
end
