class SportsIpp < ActiveRecord::Base

  belongs_to :media_file, :dependent => :destroy
  belongs_to :sports_ipp_media, :dependent => :destroy
  has_one :automated_dynamic_special

  PER_PAGE = 4

  def self.search(params, order)
    page = params[:page]
    search = params[:search]
    template_name = params[:template]
    if order != :name
      order = 'created_at DESC'
    end
    current_time = Time.current
    show_all = params[:show_all].present?
    show_only = params[:show_only].present?
    
    if !template_name.present? || template_name == 'All'
      if search
        if show_all
          if show_only
            paginate  :all, :per_page => PER_PAGE , :page => page,
                      :conditions => ['sports_ipps.name LIKE ? AND automated_dynamic_specials.last_use <= ? ', "%#{search}%", current_time], :order => order, :joins => [:automated_dynamic_special]
          else
            paginate  :all, :per_page => PER_PAGE , :page => page,
                    :conditions => ['name LIKE ?', "%#{search}%"], :order => order
          end
        else # search but not show all
          if show_only
            paginate  :all, :per_page => PER_PAGE , :page => page,
                      :conditions => ['sports_ipps.name LIKE ? AND automated_dynamic_specials.last_use < ?', "%#{search}%", current_time], :order => order, :joins => [:automated_dynamic_special]
          else
            paginate  :all, :per_page => PER_PAGE , :page => page,
                    :conditions => ['sports_ipps.name LIKE ? AND automated_dynamic_specials.last_use > ?', "%#{search}%", current_time], :order => order, :joins => [:automated_dynamic_special]
          end
        end
      else # not search
        if show_all
          if show_only
            paginate  :all, :per_page => PER_PAGE , :page => page,
                      :conditions => ['automated_dynamic_specials.last_use < ?', current_time], :order => order, :joins => [:automated_dynamic_special]
          else
            paginate  :all, :per_page => PER_PAGE , :page => page, :order => order
          end
        else # not search and not show all
          if show_only
            paginate  :all, :per_page => PER_PAGE , :page => page, 
                      :conditions => ['automated_dynamic_specials.last_use < ?', current_time], :order => order, :joins => [:automated_dynamic_special]
          else
            paginate  :all, :per_page => PER_PAGE , :page => page, 
                      :conditions => ['automated_dynamic_specials.last_use > ?', current_time], :order => order, :joins => [:automated_dynamic_special]
          end
        end
      end
    else #specific template
      template = DynamicSpecialTemplate.find_by_name(template_name)
      if template
        if search 
          if show_all
            if show_only
              paginate  :all, :per_page => PER_PAGE , :page => page,
                        :conditions => ['sports_ipps.name like ? and automated_dynamic_specials.dynamic_special_template_id = ? and automated_dynamic_specials.last_use < ?', "%#{search}%", template.id, current_time], :joins => [:automated_dynamic_special],
                        :order => order
            else
              paginate  :all, :per_page => PER_PAGE , :page => page,
                        :conditions => ['sports_ipps.name like ? and automated_dynamic_specials.dynamic_special_template_id = ?', "%#{search}%", template.id], :joins => [:automated_dynamic_special],
                        :order => order
            end
          else # template and not show all
            if show_only
              paginate  :all, :per_page => PER_PAGE , :page => page,
                        :conditions => ['sports_ipps.name like ? and automated_dynamic_specials.dynamic_special_template_id = ? AND automated_dynamic_specials.last_use < ?', "%#{search}%", template.id, current_time], :joins => [:automated_dynamic_special],
                        :order => order
            else
              paginate  :all, :per_page => PER_PAGE , :page => page,
                        :conditions => ['sports_ipps.name like ? and automated_dynamic_specials.dynamic_special_template_id = ? AND automated_dynamic_specials.last_use > ?', "%#{search}%", template.id, current_time], :joins => [:automated_dynamic_special],
                        :order => order
            end
          end
        else #not search and template
          if show_all
            if show_only
              paginate  :all,:per_page => PER_PAGE , :page => page,
                        :conditions => ['automated_dynamic_specials.dynamic_special_template_id = ? AND automated_dynamic_specials.last_use < ?', template.id, current_time], :joins => [:automated_dynamic_special],
                        :order => order
            else
              paginate  :all,:per_page => PER_PAGE , :page => page,
                        :conditions => ['automated_dynamic_specials.dynamic_special_template_id = ?', template.id], :joins => [:automated_dynamic_special],
                        :order => order
            end
          else #not search and template and not show all
            if show_only
              paginate  :all,:per_page => PER_PAGE , :page => page,
                        :conditions => ['automated_dynamic_specials.dynamic_special_template_id = ? AND automated_dynamic_specials.last_use < ?', template.id, current_time], :joins => [:automated_dynamic_special],
                        :order => order
            else
              paginate  :all,:per_page => PER_PAGE , :page => page,
                        :conditions => ['automated_dynamic_specials.dynamic_special_template_id = ? AND automated_dynamic_specials.last_use > ?', template.id, current_time], :joins => [:automated_dynamic_special],
                        :order => order
            end
          end
        end
      end
    end
  end

  def self.new_name(ads_name)
    if find_by_name(ads_name)
      version = 1
      test_name = ads_name + "_" + "%03d" % version
      while find_by_name(test_name) && version < 999
        version += 1
        test_name = ads_name + "_" + "%03d" % version
      end
      test_name 
    else
      ads_name
    end
  end
  
  def add_preview_media
    done = false
    if !self.media_file
      logger.debug "In add_preview_media and no media_file"
      if link_or_create_media self
        message = 'Media added. '
        logger.debug "In add_preview_media it says media added"
        done = true
      else
        message = 'Media failed to be added. '
        logger.debug "In add_preview_media it says media falied added"
        done = false
      end
    else
      logger.debug "In add_preview_media it thinks it has media"
    end
    {:success => done, :message => message}
  end

  def add_sports_ipp_media
    done = false
    if !self.sports_ipp_media
      if link_or_create_sports_ipp_media self
        message = 'Media added. '
        done = true
      else
        message = 'Media failed to be added. '
      end
    end
    {:success => done, :message => message}
  end

  def link_or_create_media(sports_ipp)
    media_name = sports_ipp.name + "_SPORT_IPP"
    media_filename = create_filename(media_name, ".mov")
    media_files = MediaFile.find_sports_ipp_previews(media_filename)
    logger.debug "In link_or_create_media. media_name: " + media_name
    logger.debug "In link_or_create_media. media_filename: " + media_filename
    if media_files.length == 0
      media_file = MediaFile.new
      logger.debug "In link_or_create_media. New file " 
    else
      media_file = media_files[0]
      logger.debug "In link_or_create_media. Existing file " 
    end
    
    media_file.name = media_name
    media_file.filename = media_filename
    media_file.has_audio = false
    media_file.first_use = Time.current
    media_file.last_use = Time.current + 3.months
    media_file.status = Status.find_by_value(0)
    logger.debug "In link etc. Status" + media_file.status_id.to_s
    media_file.media_folder = MediaFolder.find_by_name('Sports IPP Preview')
    logger.debug "In link etc. Folder" + media_file.media_folder_id.to_s
    media_file.media_type = MediaType.find_by_name('Sports IPP Preview')
    logger.debug "In link etc. Type" + media_file.media_type_id.to_s
    if media_file.save
      logger.debug "In link etc. Media File saved" 
    else
      logger.debug "In link etc. Media File NOT NOT saved" 
    end
    sports_ipp.media_file = media_file
    sports_ipp.save
  end

  def link_or_create_sports_ipp_media(sports_ipp)
    zip_filename = create_filename(sports_ipp.name, ".zip")
    media_file = SportsIppMedia.find_by_filename(zip_filename)

    if !media_file
      media_file = SportsIppMedia.new
    end

    media_file.filename = zip_filename
    media_file.sports_ipp_status = SportsIppStatus.find_by_message('Not Loaded')
    media_file.media_folder_id = MediaFolder.find_by_name('Sports IPP Package').id
    media_file.save
    sports_ipp.sports_ipp_media = media_file
    sports_ipp.save
  end

  def create_filename(name, extension)
    Useful.strip_filename(name).upcase + extension
  end

  def template_name
    if automated_dynamic_special.present? && automated_dynamic_special.dynamic_special_template.present?
      automated_dynamic_special.dynamic_special_template.name
    else
      'No template'
    end
  end

  def preview_ready_with_jpeg
    media_file && media_file.jpeg_exist? && media_file.status && media_file.status.message == "Ready"
  end

end
