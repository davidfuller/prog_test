class DynamicSpecialImageSpec < ActiveRecord::Base

  has_many :dynamic_special_fields
  has_many :dynamic_special_logos
  belongs_to :media_folder
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

  def logo_text
    if logo
      'Logo'
    else
      ''
    end
  end

  def promo_text
    if promo
      'Promo Image'
    else
      ''
    end
  end
  
  def self.multibrand_logo
    find_by_name('Multibrand Logo Centre')
  end

  def preview_size
    if promo
      (width/4).to_s + 'x' + (height/4).to_s
    else
      '50x50'
    end
  end

  def size_text
    width.to_s + 'x' + height.to_s
  end

  def image_description
    if image
      if promo
        if resizable
          'Resizable promo image: ' + size_text
        else
          'Promo image: ' + size_text
        end
      elsif logo
        'Logo image: ' + size_text
      end
    else
      'No image'
    end
  end

  def self.promo_types_with_all
    list = DynamicSpecialImageSpec.find(:all, :conditions => ['promo = true'], :select =>:name).map{|m| m.name}
    list.unshift('All')
  end

end