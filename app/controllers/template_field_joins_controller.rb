class TemplateFieldJoinsController < ApplicationController
  # GET /template_field_joins
  # GET /template_field_joins.xml
  def index
    @template_field_joins = TemplateFieldJoin.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @template_field_joins }
    end
  end

  # GET /template_field_joins/1
  # GET /template_field_joins/1.xml
  def show
    @template_field_join = TemplateFieldJoin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @template_field_join }
    end
  end

  # GET /template_field_joins/new
  # GET /template_field_joins/new.xml
  def new
    @template_field_join = TemplateFieldJoin.new

    @template_field_join.dynamic_special_template_id = params[:dynamic_special_template_id]
    @template_field_join.source = params[:source]
    @template_field_join.field = params[:number]||1
    @templates = DynamicSpecialTemplate.all
    @fields = DynamicSpecialField.all 

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @template_field_join }
    end
  end

  # GET /template_field_joins/1/edit
  def edit
    @template_field_join = TemplateFieldJoin.find(params[:id])
    @templates = DynamicSpecialTemplate.all
    @fields = DynamicSpecialField.all 
    @template_field_join.source = params[:source]
  end

  # POST /template_field_joins
  # POST /template_field_joins.xml
  def create
    @template_field_join = TemplateFieldJoin.new(params[:template_field_join])
    source = params[:template_field_join][:source]
    logger.debug '=======>'
    logger.debug source
    respond_to do |format|
      if @template_field_join.save
        flash[:notice] = 'Template Field was successfully created.'
        format.html { 
          if source == 'template'
            redirect_to(dynamic_special_template_path(@template_field_join.dynamic_special_template_id))
          else
            redirect_to(template_field_joins_path) 
          end
        }
        format.xml  { render :xml => @template_field_join, :status => :created, :location => @template_field_join }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @template_field_join.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /template_field_joins/1
  # PUT /template_field_joins/1.xml
  def update
    @template_field_join = TemplateFieldJoin.find(params[:id])
    source = params[:template_field_join][:source]
    
    respond_to do |format|
      if @template_field_join.update_attributes(params[:template_field_join])
        flash[:notice] = 'Template Field was successfully updated.'
        format.html { 
          if source == 'template'
            redirect_to(dynamic_special_template_path(@template_field_join.dynamic_special_template_id))
          else
            redirect_to(template_field_joins_path)
          end
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @template_field_join.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /template_field_joins/1
  # DELETE /template_field_joins/1.xml
  def destroy
    @template_field_join = TemplateFieldJoin.find(params[:id])
    dynamic_special_template_id = @template_field_join.dynamic_special_template_id
    source = params[:source]
    @template_field_join.destroy

    respond_to do |format|
      format.html { 
        if source == 'template'
          redirect_to(dynamic_special_template_path(dynamic_special_template_id))
        else
          redirect_to(template_field_joins_url)
        end
      }
      format.xml  { head :ok }
    end
  end
end
