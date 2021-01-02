class TrailerFilesController < ApplicationController
  # GET /trailer_files
  # GET /trailer_files.xml
  def index
    @trailer_files = TrailerFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trailer_files }
    end
  end

  # GET /trailer_files/1
  # GET /trailer_files/1.xml
  def show
    @trailer_file = TrailerFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trailer_file }
    end
  end

  # GET /trailer_files/new
  # GET /trailer_files/new.xml
  def new
    @trailer_file = TrailerFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trailer_file }
    end
  end

  # GET /trailer_files/1/edit
  def edit
    @trailer_file = TrailerFile.find(params[:id])
  end

  # POST /trailer_files
  # POST /trailer_files.xml
  def create
    @trailer_file = TrailerFile.new(params[:trailer_file])

    respond_to do |format|
      if @trailer_file.save
        flash[:notice] = 'TrailerFile was successfully created.'
        format.html { redirect_to(@trailer_file) }
        format.xml  { render :xml => @trailer_file, :status => :created, :location => @trailer_file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trailer_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trailer_files/1
  # PUT /trailer_files/1.xml
  def update
    @trailer_file = TrailerFile.find(params[:id])

    respond_to do |format|
      if @trailer_file.update_attributes(params[:trailer_file])
        flash[:notice] = 'TrailerFile was successfully updated.'
        format.html { redirect_to(@trailer_file) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trailer_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trailer_files/1
  # DELETE /trailer_files/1.xml
  def destroy
    @trailer_file = TrailerFile.find(params[:id])
    @trailer_file.destroy

    respond_to do |format|
      format.html { redirect_to(trailer_files_url) }
      format.xml  { head :ok }
    end
  end
end
