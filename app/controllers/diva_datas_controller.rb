class DivaDatasController < ApplicationController
  # GET /diva_datas
  # GET /diva_datas.xml
  def index
    @diva_datas = DivaData.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @diva_datas }
    end
  end

  # GET /diva_datas/1
  # GET /diva_datas/1.xml
  def show
    @diva_data = DivaData.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @diva_data }
    end
  end

  # GET /diva_datas/new
  # GET /diva_datas/new.xml
  def new
    @diva_data = DivaData.new
    @diva_statuses = DivaStatus.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @diva_data }
    end
  end

  # GET /diva_datas/1/edit
  def edit
    @diva_data = DivaData.find(params[:id])
    @diva_data.source = params[:source]
    @diva_data.trailer_id = params[:trailer_id]
    @diva_statuses = DivaStatus.all
  end

  # POST /diva_datas
  # POST /diva_datas.xml
  def create
    @diva_data = DivaData.new(params[:diva_data])

    respond_to do |format|
      if @diva_data.save
        flash[:notice] = 'DivaData was successfully created.'
        format.html { redirect_to(@diva_data) }
        format.xml  { render :xml => @diva_data, :status => :created, :location => @diva_data }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @diva_data.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /diva_datas/1
  # PUT /diva_datas/1.xml
  def update
    @diva_data = DivaData.find(params[:id])
    respond_to do |format|
      if @diva_data.update_attributes(params[:diva_data])
        flash[:notice] = 'Diva Data was successfully updated.'
        if @diva_data.source == 'trailer'
          format.html { redirect_to(trailer_path(@diva_data.trailer_id)) }
          format.xml  { head :ok }
        else
          format.html { redirect_to(@diva_data) }
          format.xml  { head :ok }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @diva_data.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /diva_datas/1
  # DELETE /diva_datas/1.xml
  def destroy
    @diva_data = DivaData.find(params[:id])
    @diva_data.destroy

    if params[:source] == 'trailer'
      trailer = Trailer.find(params[:trailer_id])
      if trailer
        trailer.diva_data_id = nil
        trailer.save
      end
    end

    respond_to do |format|
      if params[:source] == 'trailer'
        format.html { redirect_to(trailer_path(params[:trailer_id])) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(diva_datas_url) }
        format.xml  { head :ok }
      end
    end
  end
end
