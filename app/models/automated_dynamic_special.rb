class AutomatedDynamicSpecial < ActiveRecord::Base

  belongs_to :channel
  belongs_to :dynamic_special_template
  belongs_to :special_preview
  has_many :automated_dynamic_special_fields, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :channel_id , :message => 'has been already taken for this channel'
  validates_presence_of :channel
  validate :no_blank_template

  default_scope :order => :name

  PER_PAGE = 12

  def self.search(params)
    channel_id = Channel.find_by_name(params[:channel])
    template_id = DynamicSpecialTemplate.find_by_name(params[:template])
    current_time = Time.current
    search = params[:search]
    show_all = params[:show_all].present?
    page = params[:page]
    show_only = params[:show_only].present?
    issues_only = params[:show_issues].present?

    if issues_only
      all_record_with_issues(page, channel_id, search, show_all, show_only, template_id)
    else
      if channel_id # has channel
        if search # has search (including '')
          if show_all # including in the past
            if show_only # just the past
              if template_id
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", current_time, template_id]
              else
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ?', channel_id, "%#{search}%", current_time]
              end
            else
              if template_id
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['channel_id = ? AND name LIKE ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", template_id]                
              else
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['channel_id = ? AND name LIKE ?', channel_id, "%#{search}%"]
              end
            end
          else # not show all
            if show_only # just the past
              if template_id
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", current_time, template_id]
              else
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ?', channel_id, "%#{search}%", current_time]
              end
            else # just the future
              if template_id
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", current_time, template_id]
              else
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ?', channel_id, "%#{search}%", current_time]
              end
            end
          end
        else # blank search
          if show_only # just the past
            if template_id
              paginate  :all, :per_page => PER_PAGE , :page => page, 
                        :conditions => ['channel_id = ? AND last_use < ? AND dynamic_special_template_id = ?', channel_id, current_time, template_id]
            else
              paginate  :all, :per_page => PER_PAGE , :page => page, 
                        :conditions => ['channel_id = ? AND last_use < ?', channel_id, current_time]
            end
          else
            if template_id
              paginate  :all, :per_page => PER_PAGE , :page => page, 
                        :conditions => ['channel_id = ? AND dynamic_special_template_id = ?', channel_id, template_id]
            else
              paginate  :all, :per_page => PER_PAGE , :page => page, 
                        :conditions => ['channel_id = ?', channel_id]
            end
          end
        end
      else # All channels
        if search then # has search (including '')
          if show_all # including the past
            if show_only # just the past
              if template_id
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', "%#{search}%", current_time, template_id]
              else
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['name LIKE ? AND last_use < ?', "%#{search}%", current_time]
              end
            else
              if template_id
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['name LIKE ? AND dynamic_special_template_id = ?', "%#{search}%", template_id]
              else
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['name LIKE ?', "%#{search}%"]
              end
            end
          else
            if show_only # just the past
              if template_id
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                        :conditions => ['name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', "%#{search}%", current_time, template_id]
              else
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                        :conditions => ['name LIKE ? AND last_use < ?', "%#{search}%", current_time]
              end
            else # just the future
              if template_id 
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['name LIKE ? AND last_use >= ? AND dynamic_special_template_id = ?', "%#{search}%", current_time, template_id]
              else
                paginate  :all, :per_page => PER_PAGE , :page => page, 
                          :conditions => ['name LIKE ? AND last_use >= ?', "%#{search}%", current_time]
              end
            end
          end
        else # empty search
          if show_all #including the past
            if show_only # just the past
              if template_id
                paginate  :all, :per_page => PER_PAGE, :page => page, 
                          :conditions => ['last_use < ? AND dynamic_special_template_id = ?', current_time, template_id]
              else
                paginate  :all, :per_page => PER_PAGE, :page => page, 
                          :conditions => ['last_use < ?', current_time]
              end
            else
              if template_id
                paginate  :all, :per_page => PER_PAGE , :page => page,
                          :conditions => ['dynamic_special_template_id = ?', template_id]
              else
                paginate  :all, :per_page => PER_PAGE , :page => page 
              end
            end
          else
            if show_only # just the past
              if template_id
                paginate  :all, :per_page => PER_PAGE, :page => page, 
                          :conditions => ['last_use < ? AND dynamic_special_template_id = ?', current_time, template_id]
              else
                paginate  :all, :per_page => PER_PAGE, :page => page, 
                          :conditions => ['last_use < ?', current_time]
              end
            else
              if template_id
                paginate  :all, :per_page => PER_PAGE, :page => page, 
                          :conditions => ['last_use >= ? AND dynamic_special_template_id = ?', current_time, template_id]
              else
                paginate  :all, :per_page => PER_PAGE, :page => page, 
                          :conditions => ['last_use >= ?', current_time]
              end
            end
          end
        end
      end
    end
  end



  def channel_name
    if channel
      channel.name
    else
      ''
    end
  end

  def template_name
    if dynamic_special_template
      dynamic_special_template.name
    else
      ''
    end
  end
  
  def fix_nil_last_use
    if last_use.nil?
      if updated_at
        last_use = updated_at.to_date + 1.month + 1.day + 6.hours
      elsif created_at
        last_use = created_at.to_date + 1.month + 1.day + 6.hours
      else
        last_use = Time.current.to_date + 1.month + 1.day + 6.hours
      end
      self.last_use = last_use
    end
  end

  def create_fields
    joins = dynamic_special_template.template_field_joins
    joins.each do |join|
      field = AutomatedDynamicSpecialField.new
      if join.default_value != ''
        logger.debug '++++++++++++'
        logger.debug join.default_value
        if join.dynamic_special_field.dynamic_special_image_spec.logo
          logo = DynamicSpecialLogo.find(join.default_value)
          if logo
            field.the_id = join.default_value
            field.the_value = logo.filename
            field.the_display = logo.name
          else
            field.the_value = join.default_value
          end
        else
          field.the_value = join.default_value
        end
      else
        field.the_value = ''
      end
      field.template_field_join = join
      field.automated_dynamic_special = self
      field.save
    end
  end

  def multibrand_logos(logo_spec)
    DynamicSpecialLogo.find_all_by_language_id_and_dynamic_special_image_spec_id(channel.language, logo_spec)
  end

  def logos
    specs = DynamicSpecialImageSpec.find_all_by_logo(true)
    results = []
    specs.each do |spec|
      logo_set = DynamicSpecialLogo.find_all_by_language_id_and_dynamic_special_image_spec_id(channel.language, spec)
      logo_set_no_language = DynamicSpecialLogo.find_all_by_language_id_and_dynamic_special_image_spec_id(nil, spec)
      (logo_set << logo_set_no_language).flatten!
      results << {:spec => spec, :logos => logo_set}
    end
    results
  end

  def promo_field
    fields = automated_dynamic_special_fields
    fields.each do |field|
      if field.template_field_join && field.template_field_join.dynamic_special_field && field.template_field_join.dynamic_special_field.dynamic_special_image_spec && field.template_field_join.dynamic_special_field.dynamic_special_image_spec.promo
        return field
      end
    end
    nil
  end

  def promo_dynamic_special_media(field)
    if field && field.the_id
      DynamicSpecialMedia.find_by_id(field.the_id)
    else
      nil
    end
  end

  def no_blank_template
    errors.add_to_base('You must select a template') if dynamic_special_template_id.blank?
  end

  def add_special_fields(original)
    original.automated_dynamic_special_fields.each do |field|
      new_field = AutomatedDynamicSpecialField.find(field).clone
      new_field.automated_dynamic_special_id = self.id
      new_field.save
    end
  end

  def field_list
    fields = automated_dynamic_special_fields
    results = []
    fields.each do |field|
      result = {}
      result[:value] = field.the_value
      result[:id] = field.the_id
      template = field.template_field_join
      if template
        result[:field_number] = template.field
        result[:fixed] = template.fixed
        if template.dynamic_special_field
          spec = template.dynamic_special_field.dynamic_special_image_spec
          if spec
            if spec.name == 'Text'
              result[:type] = :text
            elsif spec.name == 'Switcher'
                result[:type] = :text
            elsif spec.logo
              result[:type] = :logo
            elsif spec.promo
              result[:type] = :promo
              media = promo_dynamic_special_media(field)
              if media && media.media_file && media.media_file.status
                result[:media_ready] = media.media_file.status.message
              else
                result[:media_ready] = 'No media'
              end
            else
              result[:type] = :nothing
            end
          end
        end
      end
      results << result
    end
    results
  end

  def self.all_text_fields_empty(test_field_list)
    test_field_list.each do |field|
      if field[:type] == :text && !field[:fixed] && field[:value].present?
        return false
      end
    end
    true
  end

  def self.any_missing_logo(test_field_list)
    test_field_list.each do |field|
      if field[:type] == :logo && !field[:fixed] && field[:value].blank?
        return true
      end
    end
    false
  end

  def self.any_missing_promos(test_field_list)
    test_field_list.each do |field|
      if field[:type] == :promo && !field[:fixed] && field[:value].blank?
        return true
      end
    end
    false
  end

  def self.any_media_not_ready(test_field_list)
    test_field_list.each do |field|
      if field[:type] == :promo && !field[:fixed] && field[:media_ready] != 'Ready'
        return true
      end
    end
    false
  end

  def short_ready_message
    list = field_list
    message = ''
    details =[]
    if self.class.all_text_fields_empty(list)
      if message.blank? then message = 'Text fields empty' else message = 'Multiple issues' end
      details << 'Text fields empty'  
    end
    if self.class.any_missing_logo(list)
      if message.blank? then message = 'Missing logo' else message = 'Multiple issues' end
      details << 'Missing logo'  
    end
    if self.class.any_missing_promos(list)
      if message.blank? then message = 'Missing promo' else message = 'Multiple issues' end
      details << 'Missing promo'
    end
    if self.class.any_media_not_ready(list)
      if message.blank? then message = 'Media not ready' else message = 'Multiple issues' end
      details << 'Media not ready'
    end
    if message.blank? 
      message = 'Good'
      details << 'Good'
    end
    {:message => message, :details => details}
  end

  def self.records_with_issues(channel_id, search, show_all, show_only, template_id)
    specials = search_without_pagination(channel_id, search, show_all, show_only, template_id)
    results = []
    specials.each do |special|
      list = special.field_list
      if all_text_fields_empty(list)
        results << special.id
      elsif any_missing_logo(list)
        results << special.id
      elsif any_missing_promos(list)
        results << special.id
      elsif any_media_not_ready(list)
        results << special.id
      end
    end
    results
  end

  def self.all_record_with_issues(page, channel_id, search, show_all, show_only, template_id)
    ids = records_with_issues(channel_id, search, show_all, show_only, template_id)
    begin
      paginate  ids, :per_page => PER_PAGE, :page => page
    rescue
      []
    end
  end

  def self.search_without_pagination(channel_id, search, show_all, show_only, template_id)
    current_time = Time.current
    if channel_id # has channel
      if search # has search (including '')
        if show_all # including in the past
          if show_only # just the past
            if template_id
              find  :all, :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", current_time, template_id]
            else
              find  :all, :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ?', channel_id, "%#{search}%", current_time]
            end
          else # not just the past
            if template_id
              find  :all, :conditions => ['channel_id = ? AND name LIKE ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", template_id]
            else
              find  :all, :conditions => ['channel_id = ? AND name LIKE ?', channel_id, "%#{search}%"]
            end
          end
        else # not show all
          if show_only # just the past
            if template_id
              find  :all, :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", current_time, template_id]
            else
              find  :all, :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ?', channel_id, "%#{search}%", current_time]
            end
          else # just the future
            if template_id
              find  :all, :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", current_time, template_id]
            else
              find  :all, :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ?', channel_id, "%#{search}%", current_time]
            end
          end
        end
      else # blank search
        if show_only # just the past
          if template_id
            find  :all, :conditions => ['channel_id = ? AND last_use < ? AND dynamic_special_template_id = ?', channel_id, current_time, template_id]
          else
            find  :all, :conditions => ['channel_id = ? AND last_use < ?', channel_id, current_time]
          end
        else
          if template_id
            find  :all, :conditions => ['channel_id = ? AND dynamic_special_template_id = ?', channel_id, template_id]
          else
            find  :all, :conditions => ['channel_id = ?', channel_id]
          end
        end
      end
    else # All channels
      if search then # has search (including '')
        if show_all # including the past
          if show_only # just the past
            if template_id
              find  :all, :conditions => ['name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', "%#{search}%", current_time, template_id]
            else
              find  :all, :conditions => ['name LIKE ? AND last_use < ?', "%#{search}%", current_time]
            end
          else # not just the past
            if template_id
              find  :all, :conditions => ['name LIKE ? AND dynamic_special_template_id = ?', "%#{search}%", template_id]
            else
              find  :all, :conditions => ['name LIKE ?', "%#{search}%"]
            end
          end
        else
          if show_only # just the past
            if template_id
              find  :all, :conditions => ['name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', "%#{search}%", current_time, template_id]
            else
              find  :all, :conditions => ['name LIKE ? AND last_use < ?', "%#{search}%", current_time]
            end
          else # just the future
            if template_id
              find  :all, :conditions => ['name LIKE ? AND last_use >= ? AND dynamic_special_template_id = ?', "%#{search}%", current_time, template_id]
            else
              find  :all, :conditions => ['name LIKE ? AND last_use >= ?', "%#{search}%", current_time]
            end
          end
        end
      else # empty search
        if show_all #including the past
          if show_only # just the past
            if template_id
              find  :all, :conditions => ['last_use < ? AND dynamic_special_template_id = ?', current_time, template_id]
            else
              find  :all, :conditions => ['last_use < ?', current_time]
            end
          else
            if template_id
              find  :all, :conditions => ['dynamic_special_template_id = ?', template_id]
            else
              find  :all
            end
          end
        else
          if show_only # just the past
            if template_id
              find  :all, :conditions => ['last_use < ? AND dynamic_special_template_id = ?', current_time, template_id]
            else
              find  :all, :conditions => ['last_use < ?', current_time]
            end
          else
            if template_id
              find  :all, :conditions => ['last_use >= ? AND dynamic_special_template_id = ?', current_time, template_id]
            else
              find  :all, :conditions => ['last_use >= ?', current_time]
            end
          end
        end
      end
    end
  end

  def special_preview_status
    if special_preview
      if special_preview.media_file && special_preview.media_file.status
        if special_preview.media_file.status.message == 'Ready'
          :available
        else
          :requested
        end
      end
    else
      :not_requested
    end
  end
  
  def self.xml_data(channel)
    channel_id = Channel.find_by_name(channel)
    if channel_id
      all :conditions => ['channel_id = ?', channel_id], :order => 'id'
    else
      all :order => 'id'
    end 
  end

end
