class ExceptionListsController < ApplicationController
  # GET /exception_lists
  # GET /exception_lists.xml
  def index
    @exception_lists = ExceptionList.after_this_date(params)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @exception_lists }
      format.csv 	{ send_data ExceptionList.to_csv(params), :filename => "Clipsource Exceptions-#{Time.current}.csv"}
    end
  end

  # GET /exception_lists/1
  # GET /exception_lists/1.xml
  def show
    @exception_list = ExceptionList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @exception_list }
    end
  end

  # GET /exception_lists/new
  # GET /exception_lists/new.xml
  def new
    @exception_list = ExceptionList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @exception_list }
    end
  end

  # GET /exception_lists/1/edit
  def edit
    @exception_list = ExceptionList.find(params[:id])
  end

  # POST /exception_lists
  # POST /exception_lists.xml
  def create
    @exception_list = ExceptionList.new(params[:exception_list])

    respond_to do |format|
      if @exception_list.save
        flash[:notice] = 'ExceptionList was successfully created.'
        format.html { redirect_to(@exception_list) }
        format.xml  { render :xml => @exception_list, :status => :created, :location => @exception_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @exception_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /exception_lists/1
  # PUT /exception_lists/1.xml
  def update
    @exception_list = ExceptionList.find(params[:id])

    respond_to do |format|
      if @exception_list.update_attributes(params[:exception_list])
        flash[:notice] = 'ExceptionList was successfully updated.'
        format.html { redirect_to(@exception_list) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @exception_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /exception_lists/1
  # DELETE /exception_lists/1.xml
  def destroy
    @exception_list = ExceptionList.find(params[:id])
    @exception_list.destroy

    respond_to do |format|
      format.html { redirect_to(exception_lists_url) }
      format.xml  { head :ok }
    end
  end
end
