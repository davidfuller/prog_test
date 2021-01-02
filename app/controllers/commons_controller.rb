class CommonsController < ApplicationController
  # GET /commons
  # GET /commons.xml
  def index
    @commons = Common.search(params[:search])
    @languages = Language.display

    @danish = display_language("Danish")
    @swedish = display_language("Swedish")
    @norwegian = display_language("Norwegian")
    @hungarian = display_language("Hungarian")   
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @commons }
    end
  end

  # GET /commons/1
  # GET /commons/1.xml
  def show
    @common = Common.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @common }
    end
  end

  # GET /commons/new
  # GET /commons/new.xml
  def new
    @common = Common.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @common }
    end
  end

  # GET /commons/1/edit
  def edit
    @common = Common.find(params[:id])
  end

  # POST /commons
  # POST /commons.xml
  def create
    @common = Common.new(params[:common])

    respond_to do |format|
      if @common.save
        flash[:notice] = 'The word was successfully added to the database'
        format.html { redirect_to(commons_path) }
        format.xml  { render :xml => @common, :status => :created, :location => @common }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @common.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /commons/1
  # PUT /commons/1.xml
  def update
    @common = Common.find(params[:id])

    respond_to do |format|
      if @common.update_attributes(params[:common])
        flash[:notice] = 'The word was successfully updated.'
        format.html { redirect_to(commons_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @common.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /commons/1
  # DELETE /commons/1.xml
  def destroy
    @common = Common.find(params[:id])
    @common.destroy

    respond_to do |format|
      format.html { redirect_to(commons_url) }
      format.xml  { head :ok }
    end
  end
end
