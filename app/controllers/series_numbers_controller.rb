class SeriesNumbersController < ApplicationController
  # GET /series_numbers
  # GET /series_numbers.xml
  def index
    @series_numbers = SeriesNumber.search(params[:search], params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @series_numbers }
    end
  end

  # GET /series_numbers/1
  # GET /series_numbers/1.xml
  def show
    @series_number = SeriesNumber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @series_number }
    end
  end

  # GET /series_numbers/new
  # GET /series_numbers/new.xml
  def new
    @series_number = SeriesNumber.new
    @titles = Title.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @series_number }
    end
  end

  # GET /series_numbers/1/edit
  def edit
    @series_number = SeriesNumber.find(params[:id])
    @titles = Title.all
  end

  # POST /series_numbers
  # POST /series_numbers.xml
  def create
    @series_number = SeriesNumber.new(params[:series_number])

    respond_to do |format|
      if @series_number.save
        flash[:notice] = 'Series Number was successfully created.'
        format.html { redirect_to(series_numbers_path) }
        format.xml  { render :xml => @series_number, :status => :created, :location => @series_number }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @series_number.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /series_numbers/1
  # PUT /series_numbers/1.xml
  def update
    @series_number = SeriesNumber.find(params[:id])

    respond_to do |format|
      if @series_number.update_attributes(params[:series_number])
        flash[:notice] = 'Series Number was successfully updated.'
        format.html { redirect_to(series_numbers_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @series_number.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /series_numbers/1
  # DELETE /series_numbers/1.xml
  def destroy
    @series_number = SeriesNumber.find(params[:id])
    @series_number.destroy

    respond_to do |format|
      format.html { redirect_to(series_numbers_url) }
      format.xml  { head :ok }
    end
  end
end
