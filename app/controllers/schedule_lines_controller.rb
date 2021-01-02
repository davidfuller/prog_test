class ScheduleLinesController < ApplicationController
  # GET /schedule_lines
  # GET /schedule_lines.xml
  def index
    @schedule_lines = ScheduleLine.search(params)
    @channel = ScheduleLine.channel_name(params)
    @filenames = ScheduleFile.display

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedule_lines }
    end
  end

  # GET /schedule_lines/1
  # GET /schedule_lines/1.xml
  def show
    @schedule_line = ScheduleLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule_line }
    end
  end

  # GET /schedule_lines/new
  # GET /schedule_lines/new.xml
  def new
    @schedule_line = ScheduleLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @schedule_line }
    end
  end

  # GET /schedule_lines/1/edit
  def edit
    @schedule_line = ScheduleLine.find(params[:id])
  end

  # POST /schedule_lines
  # POST /schedule_lines.xml
  def create
    @schedule_line = ScheduleLine.new(params[:schedule_line])

    respond_to do |format|
      if @schedule_line.save
        flash[:notice] = 'ScheduleLine was successfully created.'
        format.html { redirect_to(@schedule_line) }
        format.xml  { render :xml => @schedule_line, :status => :created, :location => @schedule_line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @schedule_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schedule_lines/1
  # PUT /schedule_lines/1.xml
  def update
    @schedule_line = ScheduleLine.find(params[:id])

    respond_to do |format|
      if @schedule_line.update_attributes(params[:schedule_line])
        flash[:notice] = 'ScheduleLine was successfully updated.'
        format.html { redirect_to(@schedule_line) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @schedule_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schedule_lines/1
  # DELETE /schedule_lines/1.xml
  def destroy
    @schedule_line = ScheduleLine.find(params[:id])
    @schedule_line.destroy

    respond_to do |format|
      format.html { redirect_to(schedule_lines_url) }
      format.xml  { head :ok }
    end
  end
end
