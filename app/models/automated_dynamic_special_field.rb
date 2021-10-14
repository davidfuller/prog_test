class AutomatedDynamicSpecialField < ActiveRecord::Base

  belongs_to :automated_dynamic_special
  belongs_to :template_field_join

  attr_accessor :next_field_id

  def reconcile_the_change()
    if template_field_join.dynamic_special_field.dynamic_special_image_spec.logo
      logo = DynamicSpecialLogo.find(the_id)
      if logo
        self.the_value = logo.filename
        self.the_display = logo.name
        self.save
      end
    end
    if template_field_join.dynamic_special_field.dynamic_special_image_spec.promo
      promo = DynamicSpecialMedia.find(the_id)
      if promo && promo.media_file
        self.the_value = promo.media_file.full_filename
        self.the_display = promo.media_file.name
        self.save
      end
    end
  end

  def dynamic_special_logo_url
    url = nil
    if template_field_join.dynamic_special_field.dynamic_special_image_spec.logo
      if the_id
        logo = DynamicSpecialLogo.find(the_id)
        if logo
          url = logo.display_url
        end
      end
    end
    if template_field_join.dynamic_special_field.dynamic_special_image_spec.promo
      if the_id
        promo = DynamicSpecialMedia.find_by_id(the_id)
        if promo && promo.media_file && promo.media_file.jpeg_exist?
          url = promo.media_file.jpeg_url
        end
      end
    end
    url
  end

  def field_type_name
    if template_field_join && template_field_join.dynamic_special_field && template_field_join.dynamic_special_field.dynamic_special_image_spec
      template_field_join.dynamic_special_field.dynamic_special_image_spec.name
    else
      ""
    end
  end

  def field_number
    if template_field_join
      template_field_join.field
    else
      ""
    end
  end

  def field_name
    if template_field_join && template_field_join.dynamic_special_field
      template_field_join.dynamic_special_field.name
    end
  end

  def field_value
    if template_field_join && template_field_join.dynamic_special_field && template_field_join.dynamic_special_field.dynamic_special_image_spec
      spec = template_field_join.dynamic_special_field.dynamic_special_image_spec
      if spec
        if spec.name == 'Text'
          return the_value
        elsif spec.name == 'Switcher'
          return the_value
        elsif spec.logo
          logo_full_filename
        elsif spec.promo
          promo_full_filename
        end
      else
        ""
      end
    else
      ""
    end
  end

  def promo_full_filename
    filename = nil
    if template_field_join.dynamic_special_field.dynamic_special_image_spec.promo
      if the_id
        promo = DynamicSpecialMedia.find_by_id(the_id)
        if promo && promo.media_file
          filename = promo.media_file.full_filename
        end
      end
    end
    filename
  end

  def logo_full_filename
    filename = nil
    if template_field_join.dynamic_special_field.dynamic_special_image_spec.logo
      if the_id
        logo = DynamicSpecialLogo.find(the_id)
        if logo
          filename = logo.full_filename
        end
      end
    end
    filename
  end

  def logo_name
    the_name = nil
    if template_field_join.dynamic_special_field.dynamic_special_image_spec.logo
      if the_id
        logo = DynamicSpecialLogo.find(the_id)
        if logo
          the_name = logo.name
        end
      end
    end
    the_name
  end
end
