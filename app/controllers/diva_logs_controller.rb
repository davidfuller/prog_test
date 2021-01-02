class DivaLogsController < ApplicationController
  # GET /diva_logs
  # GET /diva_logs.xml
  def index
    @diva_logs = DivaLog.all

    respond_to do |format|
      format.html {index_html(params)}
      format.xml  { render :xml => @diva_logs }
    end
  end

  # GET /diva_logs/1
  # GET /diva_logs/1.xml
  def show
    @diva_log = DivaLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @diva_log }
    end
  end

  # GET /diva_logs/new
  # GET /diva_logs/new.xml
  def new
    @diva_log = DivaLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @diva_log }
    end
  end

  # GET /diva_logs/1/edit
  def edit
    @diva_log = DivaLog.find(params[:id])
  end

  # POST /diva_logs
  # POST /diva_logs.xml
  def create
    @diva_log = DivaLog.new(params[:diva_log])

    respond_to do |format|
      if @diva_log.save
        flash[:notice] = 'DivaLog was successfully created.'
        format.html { redirect_to(@diva_log) }
        format.xml  { render :xml => @diva_log, :status => :created, :location => @diva_log }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @diva_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /diva_logs/1
  # PUT /diva_logs/1.xml
  def update
    @diva_log = DivaLog.find(params[:id])

    respond_to do |format|
      if @diva_log.update_attributes(params[:diva_log])
        flash[:notice] = 'DivaLog was successfully updated.'
        format.html { redirect_to(@diva_log) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @diva_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /diva_logs/1
  # DELETE /diva_logs/1.xml
  def destroy
    @diva_log = DivaLog.find(params[:id])
    @diva_log.destroy

    respond_to do |format|
      format.html { redirect_to(diva_logs_url) }
      format.xml  { head :ok }
    end
  end

protected
def index_html(params)
  @diva_logs = DivaLog.search(params[:search], params[:page])
end

end
