class JpegsController < ApplicationController
  # GET /jpegs
  # GET /jpegs.xml
  def index
    @jpegs = Jpeg.search(params[:folder], params[:search], params[:page])
    @folders = JpegFolder.display

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jpegs }
    end
  end

  # GET /jpegs/1
  # GET /jpegs/1.xml
  def show
    @jpeg = Jpeg.find(params[:id])
    @jpeg_next = Jpeg.next_jpeg(@jpeg, session[:jpeg_search])
    @jpeg_previous = Jpeg.previous_jpeg(@jpeg, session[:jpeg_search]) 
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @jpeg }
    end
  end

  # GET /jpegs/new
  # GET /jpegs/new.xml
  def new
    @jpeg = Jpeg.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @jpeg }
    end
  end

  # GET /jpegs/1/edit
  def edit
    @jpeg = Jpeg.find(params[:id])
  end

  # POST /jpegs
  # POST /jpegs.xml
  def create
    @jpeg = Jpeg.new(params[:jpeg])

    respond_to do |format|
      if @jpeg.save
        flash[:notice] = 'Jpeg was successfully created.'
        format.html { redirect_to(@jpeg) }
        format.xml  { render :xml => @jpeg, :status => :created, :location => @jpeg }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @jpeg.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jpegs/1
  # PUT /jpegs/1.xml
  def update
    @jpeg = Jpeg.find(params[:id])

    respond_to do |format|
      if @jpeg.update_attributes(params[:jpeg])
        flash[:notice] = 'Jpeg was successfully updated.'
        format.html { redirect_to(@jpeg) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @jpeg.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jpegs/1
  # DELETE /jpegs/1.xml
  def destroy
    @jpeg = Jpeg.find(params[:id])
    @jpeg.destroy

    respond_to do |format|
      format.html { redirect_to(jpegs_url) }
      format.xml  { head :ok }
    end
  end
end
