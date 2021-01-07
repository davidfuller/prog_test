class AutomatedDynamicSpecialField < ActiveRecord::Base

  belongs_to :automated_dynamic_special
  belongs_to :template_field_join

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
      promo = DynamicSpecialMedia.find(the_id)
      if promo && promo.media_file && promo.media_file.jpeg_exist?
        url = promo.media_file.jpeg_url
      end
    end
  end
  url
end


end
