class SpecialScheduleLogsController < ApplicationController
  # GET /special_schedule_logs
  # GET /special_schedule_logs.xml
  def index
    @special_schedule_logs = SpecialScheduleLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @special_schedule_logs }
    end
  end

  # GET /special_schedule_logs/1
  # GET /special_schedule_logs/1.xml
  def show
    @special_schedule_log = SpecialScheduleLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @special_schedule_log }
    end
  end

  # GET /special_schedule_logs/new
  # GET /special_schedule_logs/new.xml
  def new
    @special_schedule_log = SpecialScheduleLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @special_schedule_log }
    end
  end

  # GET /special_schedule_logs/1/edit
  def edit
    @special_schedule_log = SpecialScheduleLog.find(params[:id])
  end

  # POST /special_schedule_logs
  # POST /special_schedule_logs.xml
  def create
    @special_schedule_log = SpecialScheduleLog.new(params[:special_schedule_log])

    respond_to do |format|
      if @special_schedule_log.save
        flash[:notice] = 'SpecialScheduleLog was successfully created.'
        format.html { redirect_to(@special_schedule_log) }
        format.xml  { render :xml => @special_schedule_log, :status => :created, :location => @special_schedule_log }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @special_schedule_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /special_schedule_logs/1
  # PUT /special_schedule_logs/1.xml
  def update
    @special_schedule_log = SpecialScheduleLog.find(params[:id])

    respond_to do |format|
      if @special_schedule_log.update_attributes(params[:special_schedule_log])
        flash[:notice] = 'SpecialScheduleLog was successfully updated.'
        format.html { redirect_to(@special_schedule_log) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @special_schedule_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /special_schedule_logs/1
  # DELETE /special_schedule_logs/1.xml
  def destroy
    @special_schedule_log = SpecialScheduleLog.find(params[:id])
    @special_schedule_log.destroy

    respond_to do |format|
      format.html { redirect_to(special_schedule_logs_url) }
      format.xml  { head :ok }
    end
  end
end
