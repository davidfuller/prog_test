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
end

def dynamic_special_logo_url
  if template_field_join.dynamic_special_field.dynamic_special_image_spec.logo
    if the_id
      logo = DynamicSpecialLogo.find(the_id)
      if logo
        logo.display_url
      end
    end
  end
end


end
