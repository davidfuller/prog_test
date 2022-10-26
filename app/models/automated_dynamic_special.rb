class AutomatedDynamicSpecial < ActiveRecord::Base

  belongs_to :channel
  belongs_to :dynamic_special_template
  belongs_to :special_preview
  has_many :automated_dynamic_special_fields, :dependent => :destroy
  has_many :press_line_automated_dynamic_special_join

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :channel_id , :message => 'has been already taken for this channel'
  validates_presence_of :channel
  validate :no_blank_template

  default_scope :order => :name

  PER_PAGE = 12
  attr_accessor :checked

  def self.search(params)
    channel_id = Channel.find_by_name(params[:channel])
    template_id = DynamicSpecialTemplate.find_by_name(params[:template])
    current_time = Time.current
    search = params[:search]
    show_all = params[:show_all].present?
    page = params[:page]
    show_only = params[:show_only].present?
    issues_only = params[:show_issues].present?
    hide_archive = !params[:include_archive].present?
    archive_only = params[:archive_only].present?
    
    if issues_only
      all_record_with_issues(page, channel_id, search, show_all, show_only, template_id)
    else
      if channel_id # has channel
        if search # has search (including '')
          if show_all # including in the past
            if show_only # just the past
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND dynamic_special_template_id = ? AND archive = true', channel_id, "%#{search}%", current_time, template_id]
                elsif hide_archive #filter on archive 
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND dynamic_special_template_id = ? AND archive = false', channel_id, "%#{search}%", current_time, template_id]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", current_time, template_id]
                end
              else # any template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND archive = true', channel_id, "%#{search}%", current_time]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND archive = false', channel_id, "%#{search}%", current_time]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ?', channel_id, "%#{search}%", current_time]
                end
              end
            else #not just the past
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND dynamic_special_template_id = ? AND archive = true', channel_id, "%#{search}%", template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND dynamic_special_template_id = ? AND archive = false', channel_id, "%#{search}%", template_id]
                else #include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", template_id]
                end
              else # any template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND archive = true', channel_id, "%#{search}%"]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND archive = false', channel_id, "%#{search}%"]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ?', channel_id, "%#{search}%"]
                end 
              end
            end
          else # not show all
            if show_only # just the past
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND dynamic_special_template_id = ? AND archive = true', channel_id, "%#{search}%", current_time, template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND dynamic_special_template_id = ? AND archive = false', channel_id, "%#{search}%", current_time, template_id]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", current_time, template_id]
                end
              else # any template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND archive = true', channel_id, "%#{search}%", current_time]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ? AND archive = false', channel_id, "%#{search}%", current_time]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use < ?', channel_id, "%#{search}%", current_time]
                end
              end
            else # just the future
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ? AND dynamic_special_template_id = ? AND archive = true', channel_id, "%#{search}%", current_time, template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ? AND dynamic_special_template_id = ? AND archive = false', channel_id, "%#{search}%", current_time, template_id]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ? AND dynamic_special_template_id = ?', channel_id, "%#{search}%", current_time, template_id]
                end
              else # any template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ? AND archive = true', channel_id, "%#{search}%", current_time]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ? AND archive = false', channel_id, "%#{search}%", current_time]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['channel_id = ? AND name LIKE ? AND last_use >= ?', channel_id, "%#{search}%", current_time]
                end
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
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ? AND dynamic_special_template_id = ? AND archive = true', "%#{search}%", current_time, template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ? AND dynamic_special_template_id = ? AND archive = false', "%#{search}%", current_time, template_id]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', "%#{search}%", current_time, template_id]
                end
              else #any template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ? AND archive = true', "%#{search}%", current_time]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ? AND archive = false', "%#{search}%", current_time]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ?', "%#{search}%", current_time]
                end
              end
            else #not just the past
              if template_id #specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND dynamic_special_template_id = ? AND archive = true', "%#{search}%", template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND dynamic_special_template_id = ? AND archive = false', "%#{search}%", template_id]
                else  #include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND dynamic_special_template_id = ?', "%#{search}%", template_id]
                end
              else #any template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND archive = true', "%#{search}%"]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND archive = false', "%#{search}%"]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ?', "%#{search}%"]
                end
              end
            end
          else # not including the past
            if show_only # just the past
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ? AND dynamic_special_template_id = ? AND archive = true', "%#{search}%", current_time, template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ? AND dynamic_special_template_id = ? AND archive = false', "%#{search}%", current_time, template_id]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ? AND dynamic_special_template_id = ?', "%#{search}%", current_time, template_id]
                end
              else #any template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ? AND archive = true', "%#{search}%", current_time]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ? AND archive = false', "%#{search}%", current_time]
                else #include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use < ?', "%#{search}%", current_time]
                end
              end
            else # just the future
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use >= ? AND dynamic_special_template_id = ? AND archive = true', "%#{search}%", current_time, template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use >= ? AND dynamic_special_template_id = ? AND archive = false', "%#{search}%", current_time, template_id]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use >= ? AND dynamic_special_template_id = ?', "%#{search}%", current_time, template_id]
                end
              else #any template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use >= ? AND archive = true', "%#{search}%", current_time]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use >= ? AND archive = false', "%#{search}%", current_time]
                else # inclyde archive
                  paginate  :all, :per_page => PER_PAGE , :page => page, 
                            :conditions => ['name LIKE ? AND last_use >= ?', "%#{search}%", current_time]
                end
              end
            end
          end
        else # empty search
          if show_all #including the past
            if show_only # just the past
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ? AND dynamic_special_template_id = ? AND archive = true', current_time, template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ? AND dynamic_special_template_id = ? AND archive = false', current_time, template_id]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ? AND dynamic_special_template_id = ?', current_time, template_id]
                end
              else # all templates
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ? AND archive = true', current_time]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ? AND archive = false', current_time]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ?', current_time]
                end
              end
            else #past and future
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page,
                            :conditions => ['dynamic_special_template_id = ? AND archive = true', template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page,
                            :conditions => ['dynamic_special_template_id = ? AND archive = false', template_id]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page,
                            :conditions => ['dynamic_special_template_id = ?', template_id]
                end
              else #all templates
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE , :page => page,
                            :conditions => ['archive = true']
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE , :page => page,
                            :conditions => ['archive = false']
                else #include archive
                  paginate  :all, :per_page => PER_PAGE , :page => page 
                end
              end
            end
          else #not show all
            if show_only # just the past
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ? AND dynamic_special_template_id = ? AND archive = true', current_time, template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ? AND dynamic_special_template_id = ? AND archive = false', current_time, template_id]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ? AND dynamic_special_template_id = ?', current_time, template_id]
                end
              else # all templates
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ? AND archive = true', current_time]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ? AND archive = false', current_time]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use < ?', current_time]
                end
              end
            else # just the future
              if template_id # specific template
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use >= ? AND dynamic_special_template_id = ? AND archive = true', current_time, template_id]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use >= ? AND dynamic_special_template_id = ? AND archive = false', current_time, template_id]
                else #include archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use >= ? AND dynamic_special_template_id = ?', current_time, template_id]
                end
              else # all templates
                if archive_only #only archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use >= ? AND archive = true', current_time]
                elsif hide_archive #filter on archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use >= ? AND archive = false', current_time]
                else # include archive
                  paginate  :all, :per_page => PER_PAGE, :page => page, 
                            :conditions => ['last_use >= ?', current_time]
                end
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
  
  def fix_nil_first_last_use
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
    if first_use.nil?
      if created_at
        first_use = created_at.to_date + 6.hours
      else
        first_use = Time.current.to_date + 6.hours
      end
      self.first_use = first_use
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

  def promo_fields
    fields = automated_dynamic_special_fields
    results = []
    fields.each do |field|
      if field.template_field_join && field.template_field_join.dynamic_special_field && field.template_field_join.dynamic_special_field.dynamic_special_image_spec && field.template_field_join.dynamic_special_field.dynamic_special_image_spec.promo
        results << field
      end
    end
    results
  end

  def promo_dynamic_special_media(field)
    if field && field.the_id
      DynamicSpecialMedia.find_by_id(field.the_id)
    else
      nil
    end
  end

  def promo_dynamic_special_medias(fields)
    results = []
    fields.each do |field|
      if field && field.the_id
        results << DynamicSpecialMedia.find_by_id(field.the_id)
      end
    end
    results
  end

  def promo_media_status
    the_promo_field = promo_field
    if the_promo_field
      the_media = promo_dynamic_special_media(the_promo_field)
      if the_media && the_media.media_file && the_media.media_file.status
        the_media.media_file.status.message
      else
        'Missing media'
      end
    else
      'No media'
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
              result[:empty_allowed] = template.dynamic_special_field.empty_allowed
            elsif spec.name == 'Switcher'
              result[:type] = :text
              result[:empty_allowed] = template.dynamic_special_field.empty_allowed
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

  def self.any_text_fields_empty_unless_allowed(test_field_list)
    test_field_list.each do |field|
      if field[:type] == :text && !field[:fixed]
        if !field[:value].present?
          if !field[:empty_allowed]
            return true
          end
        end
      end
    end
    false
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
    valid = false
    if self.class.any_text_fields_empty_unless_allowed(list)
      if message.blank? then message = 'Text field(s) empty' else message = 'Multiple issues' end
      details << 'Text field(s) empty'  
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
      valid = true
    end
    {:message => message, :details => details, :valid => valid}
  end

  def self.records_with_issues(channel_id, search, show_all, show_only, template_id)
    specials = search_without_pagination(channel_id, search, show_all, show_only, template_id)
    results = []
    specials.each do |special|
      list = special.field_list
      if any_text_fields_empty_unless_allowed(list)
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
      else
        :not_requested
      end
    else
      :not_requested
    end
  end
  
  def self.xml_data(channel)
    channel_id = Channel.find_by_name(channel)
    if channel_id
      all :conditions => ['channel_id = ? AND archive = false', channel_id], :order => 'id'
    else
      all :conditions => ['archive = false'], :order => 'id'
    end 
  end

  def next_editable_field_id(current_id, next_field_id)
    fields = automated_dynamic_special_fields
    results = []
    fields.each do |field|
      result = {}
      template = field.template_field_join
      if template && !template.fixed
        if template.dynamic_special_field
          spec = template.dynamic_special_field.dynamic_special_image_spec
          if spec
            if spec.name == 'Text' || spec.name == 'Switcher' || spec.logo
              result[:field_number] = template.field
              result[:id] = field.id
              result[:logo] = spec.logo
              results << result
            end
          end
        end
      end
    end
    if results.length > 0
      if next_field_id
        next_id = next_field_id.delete("^0-9").to_i
        if next_id > 0
          sorted = results.sort_by{|field| field[:field_number]}
          index = sorted.index{|field| field[:id] == next_id}
          if !index.nil?
            if results[index][:logo]
              next_one = results[index]
            else
              if next_id == current_id
                next_one = results[index + 1] 
              else
                next_one = results[index]
              end
            end
            if next_one.nil?
              next_one = results[0]
            end
            return next_one[:id]
          else
            return results[0][:id]
          end
        end
      else
        return results[0][:id]
      end
    else
      return nil
    end
  end

  def self.report_search(params)
    channel_id = Channel.find_by_name(params[:channel])
    template_id = DynamicSpecialTemplate.find_by_name(params[:template])

    if params[:end_date].present?
      end_date = Date.parse(params[:end_date]).strftime('%F')
    else
      end_date = Date.today.beginning_of_month - 1.day
    end

    if params[:start_date].present?
      start_date = Date.parse(params[:start_date]).strftime('%F')
    else
      start_date = end_date.beginning_of_month
    end

    if channel_id # has channel
      if template_id # specific template
        find :all, :conditions => ['channel_id = ? AND dynamic_special_template_id = ? AND DATE(created_at) >= ? AND DATE(created_at) <= ?', channel_id, template_id, start_date, end_date], :order => :created_at
      else # any template
        find :all, :conditions => ['channel_id = ? AND DATE(created_at) >= ? AND DATE(created_at) <= ?', channel_id, start_date, end_date], :order => :created_at
      end
    else # any channel
      if template_id # specific template
        find :all, :conditions => ['dynamic_special_template_id = ? AND DATE(created_at) >= ? AND DATE(created_at) <= ?', template_id, start_date, end_date], :order => :created_at
      else # any template
        find :all, :conditions => ['DATE(created_at) >= ? AND DATE(created_at) <= ?', start_date, end_date], :order => :created_at
      end
    end        
  end

  def self.default_report_dates
    end_date = Time.now.beginning_of_month - 1.day
    start_date = end_date.beginning_of_month - 11.month
    {:start_date => start_date.to_s(:broadcast_calendar_date_only), :end_date => end_date.to_s(:broadcast_calendar_date_only)}
  end

  def self.duplicate_name(original_name)
    new_name = original_name + ' Copy'
    if find_by_name(new_name)
      the_number = 1
      new_name = original_name + ' Copy ' + the_number.to_s
      while find_by_name(new_name)
        the_number += 1
        new_name = original_name + ' Copy ' + the_number.to_s
        break if the_number > 100
      end
    end
    new_name
  end

  def data_for_preview
    result = {}
    result[:name] = name
    if dynamic_special_template
      result[:page] = dynamic_special_template.page_169
      the_fields = []
      automated_dynamic_special_fields.each do |special_field|
        the_fields[special_field.field_number.to_i] = special_field.field_value
      end
      result[:fields] = the_fields
    end
    result
  end

  def self.to_csv(result)

    if result
			columns = %w{name page field_01 field_02 field_03 field_04 field_05 field_06 field_07 field_08 field_09 field_010}
			output = "\xEF\xBB\xBF" + columns.join(",") + "\n"
      processed = []
      processed <<	'"' + result[:name].to_s.gsub('"', '""') + '"'
      processed <<	'"' + result[:page].to_s.gsub('"', '""') + '"'

      for i in 1..10 do
        if result[:fields][i].present?
          processed <<	'"' + "\t" + result[:fields][i].to_s.gsub('"', '""') + '"'
        else
          processed << ""
        end
      end
		  output << processed.join(",") + "\n"
	  end
		output
	end

  def self.available_for_schedule(params)
    channel_id = Channel.find_by_name(params[:channel])
    priority_date = params[:priority_date]
    template_id = DynamicSpecialTemplate.find_by_name(params[:template])
    if priority_date.blank?
      schedule_date = Date.parse(Time.new().to_s) # midnight today
    else
      schedule_date = Date.parse(priority_date)
    end
    search = params[:search]

    if search
      if template_id
        results = find  :all, :conditions => ['channel_id = ? AND DATE(first_use) <= ? AND DATE(last_use) >= ? AND dynamic_special_template_id = ? AND name LIKE ?', channel_id, schedule_date, schedule_date, template_id, "%#{search}%"]
      else
        results = find  :all, :conditions => ['channel_id = ? AND DATE(first_use) <= ? AND DATE(last_use) >= ? AND name LIKE ?', channel_id, schedule_date, schedule_date, "%#{search}%"]
      end
    else
      if template_id
        results = find  :all, :conditions => ['channel_id = ? AND DATE(first_use) <= ? AND DATE(last_use) >= ? AND dynamic_special_template_id = ?', channel_id, schedule_date, schedule_date, template_id]
      else
        results = find  :all, :conditions => ['channel_id = ? AND DATE(first_use) <= ? AND DATE(last_use) >= ?', channel_id, schedule_date, schedule_date]
      end
    end

    if params[:automated_dynamic_special_ids]
      results.each do |result|
        if params[:automated_dynamic_special_ids].include? result.id.to_s
          result.checked = true
        else
          result.checked = false
        end
      end
    end
    results
  end



  def self.fix_first_use
    my_count = 0
    adss = find :all, :conditions => ['first_use is NULL']
    adss.each do |ads|
      if ads.first_use.nil?
        if ads.created_at
          ads.first_use = ads.created_at.to_date + 6.hours
        else
          ads.first_use = Time.current.to_date + 6.hours
        end
        if ads.save
          my_count += 1
        end
      end  
    end
    my_count
  end

  def self.scheduled_on_date_channel(channel_name, start, stop)
    channel = Channel.find_by_name(channel_name)
    result = []
    if channel
      ads = AutomatedDynamicSpecial.find :all, :conditions => ['channel_id = ? and press_line_automated_dynamic_special_joins.tx_time >= ? and press_line_automated_dynamic_special_joins.tx_time <= ?',channel.id, start, stop ], 
                                          :joins => :press_line_automated_dynamic_special_join
      ads.each do |special|
        if !special_exists_in_list(special, result)
          result << {:special => special, :count => 1}
        end
      end
    end
    result
  end

  def self.special_exists_in_list(special, list)
    list.each do |item|
      if item[:special].id == special.id
        item[:count] += 1
        return true
      end
    end
    return false
  end
end
