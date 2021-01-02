class IgnoresController < ApplicationController
  # GET /ignores
  # GET /ignores.xml
  def index
    @ignores = Ignore.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ignores }
    end
  end

  # GET /ignores/1
  # GET /ignores/1.xml
  def show
    @ignore = Ignore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ignore }
    end
  end

  # GET /ignores/new
  # GET /ignores/new.xml
  def new
    @ignore = Ignore.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ignore }
    end
  end

  # GET /ignores/1/edit
  def edit
    @ignore = Ignore.find(params[:id])
  end

  # POST /ignores
  # POST /ignores.xml
  def create
    @ignore = Ignore.new(params[:ignore])

    respond_to do |format|
      if @ignore.save
        flash[:notice] = 'Successfully created.'
        format.html { redirect_to(ignores_url) }
        format.xml  { render :xml => @ignore, :status => :created, :location => @ignore }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ignore.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ignores/1
  # PUT /ignores/1.xml
  def update
    @ignore = Ignore.find(params[:id])

    respond_to do |format|
      if @ignore.update_attributes(params[:ignore])
        flash[:notice] = 'Successfully updated.'
        format.html { redirect_to(ignores_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ignore.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ignores/1
  # DELETE /ignores/1.xml
  def destroy
    @ignore = Ignore.find(params[:id])
    @ignore.destroy

    respond_to do |format|
      format.html { redirect_to(ignores_url) }
      format.xml  { head :ok }
    end
  end
end
