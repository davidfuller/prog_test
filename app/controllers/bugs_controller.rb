class BugsController < ApplicationController
  # GET /bugs
  # GET /bugs.xml
  def index
    @bugs = Bug.search(params[:channel])
    remove_v4 = true
    @channel_display = Channel.display(remove_v4)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  #{ render :xml => @bugs }
    end
  end

  # GET /bugs/1
  # GET /bugs/1.xml
  def show
    @bug = Bug.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bug }
    end
  end

  # GET /bugs/new
  # GET /bugs/new.xml
  def new
    @bug = Bug.new
    @channels = Channel.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bug }
    end
  end

  # GET /bugs/1/edit
  def edit
    @bug = Bug.find(params[:id])
    @channels = Channel.all
  end

  # POST /bugs
  # POST /bugs.xml
  def create
    @bug = Bug.new(params[:bug])
    @channels = Channel.all
    respond_to do |format|
      if @bug.save
        flash[:notice] = 'Bug was successfully created.'
        format.html { redirect_to bugs_path(:channel => session[:bug_channel]) }
        format.xml  { render :xml => @bug, :status => :created, :location => @bug }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bug.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bugs/1
  # PUT /bugs/1.xml
  def update
    @bug = Bug.find(params[:id])
    @channels = Channel.all
    respond_to do |format|
      if @bug.update_attributes(params[:bug])
        flash[:notice] = 'Bug was successfully updated.'
        format.html { redirect_to bugs_path(:channel => session[:bug_channel]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bug.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bugs/1
  # DELETE /bugs/1.xml
  def destroy
    @bug = Bug.find(params[:id])
    channel = @bug.channel_name
    @bug.destroy

    respond_to do |format|
      format.html { redirect_to(bugs_url(:channel => session[:bug_channel])) }
      format.xml  { head :ok }
    end
  end
end
