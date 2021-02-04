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

  def media_folder
    if dynamic_special_image_spec && dynamic_special_image_spec.media_folder
      dynamic_special_image_spec.media_folder
    else
      nil
    end
  end

  def media_folder_name
    folder = media_folder
    if media_folder
      media_folder.name
    else
      ""
    end
  end

  def full_filename
    folder = media_folder
    if folder
      folder.folder + filename
    else
      filename
    end
  end

end
