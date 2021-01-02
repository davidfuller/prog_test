class DivaStatusesController < ApplicationController
  # GET /diva_statuses
  # GET /diva_statuses.xml
  def index
    @diva_statuses = DivaStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @diva_statuses }
    end
  end

  # GET /diva_statuses/1
  # GET /diva_statuses/1.xml
  def show
    @diva_status = DivaStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @diva_status }
    end
  end

  # GET /diva_statuses/new
  # GET /diva_statuses/new.xml
  def new
    @diva_status = DivaStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @diva_status }
    end
  end

  # GET /diva_statuses/1/edit
  def edit
    @diva_status = DivaStatus.find(params[:id])
  end

  # POST /diva_statuses
  # POST /diva_statuses.xml
  def create
    @diva_status = DivaStatus.new(params[:diva_status])

    respond_to do |format|
      if @diva_status.save
        flash[:notice] = 'Diva Status Message was successfully created.'
        format.html { redirect_to(diva_statuses_path) }
        format.xml  { render :xml => @diva_status, :status => :created, :location => @diva_status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @diva_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /diva_statuses/1
  # PUT /diva_statuses/1.xml
  def update
    @diva_status = DivaStatus.find(params[:id])

    respond_to do |format|
      if @diva_status.update_attributes(params[:diva_status])
        flash[:notice] = 'DivaStatus was successfully updated.'
        format.html { redirect_to(diva_statuses_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @diva_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /diva_statuses/1
  # DELETE /diva_statuses/1.xml
  def destroy
    @diva_status = DivaStatus.find(params[:id])
    @diva_status.destroy

    respond_to do |format|
      format.html { redirect_to(diva_statuses_url) }
      format.xml  { head :ok }
    end
  end
end
