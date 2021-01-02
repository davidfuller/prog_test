class DynamicSpecialImageSpec < ActiveRecord::Base

  has_many :dynamic_special_fields
  has_many :dynamic_special_logos
  default_scope :order =>  'name'
  
  def image_text
    if image
      'Has image'
    else
      ''
    end
  end
  
  def resizable_text
    if resizable
      'Resizeable'
    else
      ''
    end
  end

  def self.multibrand_logo
    find_by_name('Multibrand Logo Centre')
  end

end