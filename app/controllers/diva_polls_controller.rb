class DivaPollsController < ApplicationController
  # GET /diva_polls
  # GET /diva_polls.xml
  def index
    @diva_polls = DivaPoll.all

    respond_to do |format|
      format.html {index_html(params)}
      format.xml  { render :xml => @diva_polls }
    end
  end

  # GET /diva_polls/1
  # GET /diva_polls/1.xml
  def show
    @diva_poll = DivaPoll.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @diva_poll }
    end
  end

  # GET /diva_polls/new
  # GET /diva_polls/new.xml
  def new
    @diva_poll = DivaPoll.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @diva_poll }
    end
  end

  # GET /diva_polls/1/edit
  def edit
    @diva_poll = DivaPoll.find(params[:id])
  end

  # POST /diva_polls
  # POST /diva_polls.xml
  def create
    @diva_poll = DivaPoll.new(params[:diva_poll])

    respond_to do |format|
      if @diva_poll.save
        flash[:notice] = 'DivaPoll was successfully created.'
        format.html { redirect_to(@diva_poll) }
        format.xml  { render :xml => @diva_poll, :status => :created, :location => @diva_poll }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @diva_poll.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /diva_polls/1
  # PUT /diva_polls/1.xml
  def update
    @diva_poll = DivaPoll.find(params[:id])

    respond_to do |format|
      if @diva_poll.update_attributes(params[:diva_poll])
        flash[:notice] = 'DivaPoll was successfully updated.'
        format.html { redirect_to(@diva_poll) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @diva_poll.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /diva_polls/1
  # DELETE /diva_polls/1.xml
  def destroy
    @diva_poll = DivaPoll.find(params[:id])
    @diva_poll.destroy

    respond_to do |format|
      format.html { redirect_to(diva_polls_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def index_html(params)
    @diva_polls = DivaPoll.all_paged(params[:page])
  end
end
