class PressFilenamesController < ApplicationController
  # GET /press_filenames
  # GET /press_filenames.xml
  def index
    @press_filenames = PressFilename.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @press_filenames }
    end
  end

  # GET /press_filenames/1
  # GET /press_filenames/1.xml
  def show
    @press_filename = PressFilename.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @press_filename }
    end
  end

  # GET /press_filenames/new
  # GET /press_filenames/new.xml
  def new
    @press_filename = PressFilename.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @press_filename }
    end
  end

  # GET /press_filenames/1/edit
  def edit
    @press_filename = PressFilename.find(params[:id])
  end

  # POST /press_filenames
  # POST /press_filenames.xml
  def create
    @press_filename = PressFilename.new(params[:press_filename])

    respond_to do |format|
      if @press_filename.save
        flash[:notice] = 'PressFilename was successfully created.'
        format.html { redirect_to(@press_filename) }
        format.xml  { render :xml => @press_filename, :status => :created, :location => @press_filename }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @press_filename.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /press_filenames/1
  # PUT /press_filenames/1.xml
  def update
    @press_filename = PressFilename.find(params[:id])

    respond_to do |format|
      if @press_filename.update_attributes(params[:press_filename])
        flash[:notice] = 'PressFilename was successfully updated.'
        format.html { redirect_to(@press_filename) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @press_filename.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /press_filenames/1
  # DELETE /press_filenames/1.xml
  def destroy
    @press_filename = PressFilename.find(params[:id])
    @press_filename.destroy

    respond_to do |format|
      format.html { redirect_to(press_filenames_url) }
      format.xml  { head :ok }
    end
  end
end
