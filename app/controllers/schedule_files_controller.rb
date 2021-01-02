class ScheduleFilesController < ApplicationController
  # GET /schedule_files
  # GET /schedule_files.xml
  def index
    @schedule_files = ScheduleFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedule_files }
    end
  end

  # GET /schedule_files/1
  # GET /schedule_files/1.xml
  def show
    @schedule_file = ScheduleFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule_file }
    end
  end

  # GET /schedule_files/new
  # GET /schedule_files/new.xml
  def new
    @schedule_file = ScheduleFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @schedule_file }
    end
  end

  # GET /schedule_files/1/edit
  def edit
    @schedule_file = ScheduleFile.find(params[:id])
  end

  # POST /schedule_files
  # POST /schedule_files.xml
  def create
    @schedule_file = ScheduleFile.new(params[:schedule_file])

    respond_to do |format|
      if @schedule_file.save
        flash[:notice] = 'ScheduleFile was successfully created.'
        format.html { redirect_to(@schedule_file) }
        format.xml  { render :xml => @schedule_file, :status => :created, :location => @schedule_file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @schedule_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schedule_files/1
  # PUT /schedule_files/1.xml
  def update
    @schedule_file = ScheduleFile.find(params[:id])

    respond_to do |format|
      if @schedule_file.update_attributes(params[:schedule_file])
        flash[:notice] = 'ScheduleFile was successfully updated.'
        format.html { redirect_to(@schedule_file) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @schedule_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schedule_files/1
  # DELETE /schedule_files/1.xml
  def destroy
    @schedule_file = ScheduleFile.find(params[:id])
    @schedule_file.destroy

    respond_to do |format|
      format.html { redirect_to(schedule_files_url) }
      format.xml  { head :ok }
    end
  end
end
