class AutomatedDynamicSpecial < ActiveRecord::Base

  belongs_to :channel
  belongs_to :dynamic_special_template
  has_many :automated_dynamic_special_fields, :dependent => :destroy

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

end
