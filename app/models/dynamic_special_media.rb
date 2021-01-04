class DynamicSpecialMedia < ActiveRecord::Base
  belongs_to :media_file
  belongs_to :dynamic_special_image_spec
end
