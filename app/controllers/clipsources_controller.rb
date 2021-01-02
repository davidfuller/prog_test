class ClipsourcesController < ApplicationController
  # GET /clipsources
  # GET /clipsources.xml
  def index
    @clipsources = Clipsource.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clipsources }
    end
  end

  # GET /clipsources/1
  # GET /clipsources/1.xml
  def show
    @clipsource = Clipsource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clipsource }
    end
  end

  # GET /clipsources/new
  # GET /clipsources/new.xml
  def new
    @clipsource = Clipsource.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clipsource }
    end
  end

  # GET /clipsources/1/edit
  def edit
    @clipsource = Clipsource.find(params[:id])
  end

  # POST /clipsources
  # POST /clipsources.xml
  def create
    @clipsource = Clipsource.new(params[:clipsource])

    respond_to do |format|
      if @clipsource.save
        flash[:notice] = 'Clipsource EIDR replacement was successfully created.'
        format.html { redirect_to(clipsources_path) }
        format.xml  { render :xml => @clipsource, :status => :created, :location => @clipsource }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @clipsource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clipsources/1
  # PUT /clipsources/1.xml
  def update
    @clipsource = Clipsource.find(params[:id])

    respond_to do |format|
      if @clipsource.update_attributes(params[:clipsource])
        flash[:notice] = 'Clipsource EIDR replacement was successfully updated.'
        format.html { redirect_to(clipsources_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @clipsource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clipsources/1
  # DELETE /clipsources/1.xml
  def destroy
    @clipsource = Clipsource.find(params[:id])
    @clipsource.destroy

    respond_to do |format|
      format.html { redirect_to(clipsources_url) }
      format.xml  { head :ok }
    end
  end
end
