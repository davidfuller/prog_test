class TrailerHouseNumberPrefixesController < ApplicationController
  # GET /trailer_house_number_prefixes
  # GET /trailer_house_number_prefixes.xml
  def index
    @trailer_house_number_prefixes = TrailerHouseNumberPrefix.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trailer_house_number_prefixes }
    end
  end

  # GET /trailer_house_number_prefixes/1
  # GET /trailer_house_number_prefixes/1.xml
  def show
    @trailer_house_number_prefix = TrailerHouseNumberPrefix.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trailer_house_number_prefix }
    end
  end

  # GET /trailer_house_number_prefixes/new
  # GET /trailer_house_number_prefixes/new.xml
  def new
    @trailer_house_number_prefix = TrailerHouseNumberPrefix.new
    @languages = Language.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trailer_house_number_prefix }
    end
  end

  # GET /trailer_house_number_prefixes/1/edit
  def edit
    @trailer_house_number_prefix = TrailerHouseNumberPrefix.find(params[:id])
    @languages = Language.all
  end

  # POST /trailer_house_number_prefixes
  # POST /trailer_house_number_prefixes.xml
  def create
    @trailer_house_number_prefix = TrailerHouseNumberPrefix.new(params[:trailer_house_number_prefix])

    respond_to do |format|
      if @trailer_house_number_prefix.save
        flash[:notice] = 'Trailer House Number Prefix was successfully created.'
        format.html { redirect_to trailer_house_number_prefixes_url }
        format.xml  { render :xml => @trailer_house_number_prefix, :status => :created, :location => @trailer_house_number_prefix }
      else
        format.html { @languages = Language.all
                      render :action => "new" }
        format.xml  { render :xml => @trailer_house_number_prefix.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trailer_house_number_prefixes/1
  # PUT /trailer_house_number_prefixes/1.xml
  def update
    @trailer_house_number_prefix = TrailerHouseNumberPrefix.find(params[:id])

    respond_to do |format|
      if @trailer_house_number_prefix.update_attributes(params[:trailer_house_number_prefix])
        flash[:notice] = 'Trailer House Number Prefix was successfully updated.'
        format.html { redirect_to trailer_house_number_prefixes_url }
        format.xml  { head :ok }
      else
        format.html { @languages = Language.all
                      render :action => "edit" }
        format.xml  { render :xml => @trailer_house_number_prefix.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trailer_house_number_prefixes/1
  # DELETE /trailer_house_number_prefixes/1.xml
  def destroy
    @trailer_house_number_prefix = TrailerHouseNumberPrefix.find(params[:id])
    @trailer_house_number_prefix.destroy

    respond_to do |format|
      format.html { redirect_to(trailer_house_number_prefixes_url) }
      format.xml  { head :ok }
    end
  end
end
