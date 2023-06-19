class SportsIppMedia < ActiveRecord::Base
  belongs_to :sports_ipp_status
  has_one :sports_ipp
  belongs_to :media_folder

  attr_accessor :issue
  attr_accessor :notice

  def self.upload(params)
    sports_ipp_media = find(params[:id])
    do_it = false
    
    if sports_ipp_media
      upload_file = params[:file]
      sports_ipp_media.issue = false
      
      case upload_file.content_type 
      when 'application/zip', 'application/x-zip-compressed'
        dest_filename = sports_ipp_media.filename
        media_folder_name = sports_ipp_media.media_folder.name
        filename = Rails.root.join('public','data','special','Sports_IPP', dest_filename)
        do_it = true
      else
        sports_ipp_media.notice = "Invalid file type. Expected: 'application/zip' or 'application/x-zip-compressed'. Uploaded: " + upload_file.content_type
        sports_ipp_media.issue = true
        do_it = false
      end
      
      if do_it
        create_folder_if_not_exist(filename)
        File.open(filename, 'wb') do |file|
          file.write(upload_file.read)
        end
        sports_ipp_media.original_filename = upload_file.original_filename
        sports_ipp_media.notice = upload_file.original_filename + " uploaded. Content type: " + upload_file.content_type
        status_not_loaded = SportsIppStatus.find_by_message('Not Loaded')
        status_preview_ready = SportsIppStatus.find_by_message('Preview Ready')
        status_package_ready = SportsIppStatus.find_by_message('Package Ready')
        status_ready = SportsIppStatus.find_by_message('Ready')
        if sports_ipp_media.sports_ipp_status == status_not_loaded
          sports_ipp_media.sports_ipp_status = status_package_ready
        elsif sports_ipp_media.sports_ipp_status == status_preview_ready
          sports_ipp_media.sports_ipp_status = status_ready
        end
      end
      sports_ipp_media.save
    end
    sports_ipp_media
  end

  def self.create_folder_if_not_exist(filename)
    dirname = File.dirname(filename)
    Dir.mkdir(dirname) unless File.directory?(dirname)
  end

  def download_path
    '/data/special/Sports_IPP/' + filename
  end

  def download_file_exists?
    File.file?(Rails.public_path + download_path)
  end

  def self.package_uploaded(media_file_id)
    media_file = MediaFile.find(media_file_id)
    if media_file && media_file.sports_ipp && media_file.sports_ipp.sports_ipp_media
      sports_ipp_media = media_file.sports_ipp.sports_ipp_media
      status_not_loaded = SportsIppStatus.find_by_message('Not Loaded')
      status_preview_ready = SportsIppStatus.find_by_message('Preview Ready')
      status_package_ready = SportsIppStatus.find_by_message('Package Ready')
      status_ready = SportsIppStatus.find_by_message('Ready')
      if sports_ipp_media.sports_ipp_status == status_not_loaded
        sports_ipp_media.sports_ipp_status = status_package_ready
      elsif sports_ipp_media.sports_ipp_status == status_preview_ready
        sports_ipp_media.sports_ipp_status = status_ready
      end
      if sports_ipp_media.save
        sports_ipp_media
      else
        nil
      end
    else
      nil
    end
  end


end
