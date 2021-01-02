class DynamicSpecialLogo < ActiveRecord::Base

  belongs_to :dynamic_special_image_spec
  belongs_to :language
  default_scope :order => 'language_id, name'

  def display_url
    if dynamic_special_image_spec
      file = dynamic_special_image_spec.display_folder + display_filename
      if File.file?("#{Rails.root}/public" + file)
        file
      else
        dynamic_special_image_spec.display_folder + 'EMPTY.png'
      end
    end
  end

end
