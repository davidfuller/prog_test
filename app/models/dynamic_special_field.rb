class DynamicSpecialField < ActiveRecord::Base

  belongs_to :dynamic_special_image_spec
  has_many :template_field_joins
  
  default_scope :order =>  'name'

end
