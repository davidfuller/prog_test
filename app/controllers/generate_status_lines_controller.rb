class GenerateStatusLinesController < ApplicationController
  # GET /generate_status_lines
  # GET /generate_status_lines.xml
  def index
    if params[:repoll] && params[:repoll] == '1'
      GenerateStatusLine.process
    end
    @generate_status_lines = GenerateStatusLine.search(params[:on_air_date])
    if !params[:show_all]
      @generate_status_lines = GenerateStatusLine.filter_top_letter(@generate_status_lines)
    end
    @generate_data = GenerateStatusLine.generate_data(@generate_status_lines)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @generate_status_lines }
    end
  end

  # GET /generate_status_lines/1
  # GET /generate_status_lines/1.xml
  def show
    @generate_status_line = GenerateStatusLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @generate_status_line }
    end
  end

  # GET /generate_status_lines/new
  # GET /generate_status_lines/new.xml
  def new
    @generate_status_line = GenerateStatusLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @generate_status_line }
    end
  end

  # GET /generate_status_lines/1/edit
  def edit
    @generate_status_line = GenerateStatusLine.find(params[:id])
  end

  # POST /generate_status_lines
  # POST /generate_status_lines.xml
  def create
    @generate_status_line = GenerateStatusLine.new(params[:generate_status_line])

    respond_to do |format|
      if @generate_status_line.save
        flash[:notice] = 'GenerateStatusLine was successfully created.'
        format.html { redirect_to(@generate_status_line) }
        format.xml  { render :xml => @generate_status_line, :status => :created, :location => @generate_status_line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @generate_status_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /generate_status_lines/1
  # PUT /generate_status_lines/1.xml
  def update
    @generate_status_line = GenerateStatusLine.find(params[:id])

    respond_to do |format|
      if @generate_status_line.update_attributes(params[:generate_status_line])
        flash[:notice] = 'GenerateStatusLine was successfully updated.'
        format.html { redirect_to(@generate_status_line) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @generate_status_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /generate_status_lines/1
  # DELETE /generate_status_lines/1.xml
  def destroy
    @generate_status_line = GenerateStatusLine.find(params[:id])
    @generate_status_line.destroy

    respond_to do |format|
      format.html { redirect_to(generate_status_lines_url(:on_air_date => params[:on_air_date], :repoll => '1')) }
      format.xml  { head :ok }
    end
  end
end
