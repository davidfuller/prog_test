class DivaTasksController < ApplicationController
  # GET /diva_tasks
  # GET /diva_tasks.xml
  def index
    @diva_tasks = DivaTask.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @diva_tasks }
    end
  end

  # GET /diva_tasks/1
  # GET /diva_tasks/1.xml
  def show
    @diva_task = DivaTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @diva_task }
    end
  end

  # GET /diva_tasks/new
  # GET /diva_tasks/new.xml
  def new
    @diva_task = DivaTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @diva_task }
    end
  end

  # GET /diva_tasks/1/edit
  def edit
    @diva_task = DivaTask.find(params[:id])
  end

  # POST /diva_tasks
  # POST /diva_tasks.xml
  def create
    @diva_task = DivaTask.new(params[:diva_task])

    respond_to do |format|
      if @diva_task.save
        flash[:notice] = 'DivaTask was successfully created.'
        format.html { redirect_to(@diva_task) }
        format.xml  { render :xml => @diva_task, :status => :created, :location => @diva_task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @diva_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /diva_tasks/1
  # PUT /diva_tasks/1.xml
  def update
    @diva_task = DivaTask.find(params[:id])

    respond_to do |format|
      if @diva_task.update_attributes(params[:diva_task])
        flash[:notice] = 'DivaTask was successfully updated.'
        format.html { redirect_to(@diva_task) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @diva_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /diva_tasks/1
  # DELETE /diva_tasks/1.xml
  def destroy
    @diva_task = DivaTask.find(params[:id])
    @diva_task.destroy

    respond_to do |format|
      format.html { redirect_to(diva_tasks_url) }
      format.xml  { head :ok }
    end
  end
end
