class MediaFile < ActiveRecord::Base

  belongs_to :media_folder
  has_and_belongs_to_many :countdown_ipps
  has_and_belongs_to_many :promos
  belongs_to :media_type
  belongs_to :status
  has_one :trailer
  has_one :special_preview
  has_one :dynamic_special_media
  
  default_scope :order => 'first_use, media_type_id, filename'
  validates_uniqueness_of :filename, :message => " is already in the system"
  
  MAX_FOLDER_CLIPS = 450
  MAX_FOLDER_WITH_AUDIO_CLIPS = 225
  
  require 'useful'
  
  attr_accessor :source
  attr_accessor :promo_id
  attr_accessor :notice
  attr_accessor :issue
  attr_accessor :trailer_id
  attr_accessor :special_preview_id
  attr_accessor :dynamic_special_media_id
  attr_accessor :next_prefix
  attr_accessor :automated_dynamic_special_id
  attr_accessor :field_id
  
  def self.search(params)
    if params[:filename]
      find_all_by_filename(params[:filename])
    else
      type = MediaType.find_by_name(params[:media_type_display])
      spec = params[:spec_id]
      if params[:search].nil? or params[:search].empty?
        if type
          if spec
            paginate  :per_page => 12, :page =>params[:page],
                      :joins => :dynamic_special_media,
                      :conditions => ['media_type_id = ? and dynamic_special_medias.dynamic_special_image_spec_id = ?', type.id, spec]
          else
            paginate  :per_page => 12, :page =>params[:page],
                      :conditions => ['media_type_id = ?', type.id]
          end
        else
          paginate  :per_page => 12, :page =>params[:page]
        end
      else
        if type
          if spec
            paginate  :per_page => 12, :page =>params[:page],
                      :joins => :dynamic_special_media,
                      :conditions => ['name LIKE ? and media_type_id = ? and dynamic_special_medias.dynamic_special_image_spec_id = ?', "%#{params[:search]}%", type.id, spec]
          else
            paginate  :per_page => 12, :page =>params[:page],
                      :conditions => ['name LIKE ? and media_type_id = ?', "%#{params[:search]}%", type.id]
          end
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ?', "%#{params[:search]}%"]
        end
      end
    end
  end 
  
  def self.unready
    ready = Status.find_by_message('Ready')
    find(:all, :conditions => ['status_id <> ?', ready.id ])
  end
  
  def first_promo_id
    if promos.count > 0
      fp_id = promos.first.id
    else
      0
    end
  end
  
  def self.past_last_use(params)
    
    type = MediaType.find_by_name(params[:media_type_display])
    if type
      if Useful.date?(params[:last_use_date])
        last_use_date = Date.parse(params[:last_use_date]).strftime('%F')
        if params[:search]
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ? and DATE(last_use) <= ? and media_type_id =?', "%#{params[:search]}%", last_use_date, type.id]
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['DATE(last_use) <= ? and media_type_id =?', last_use_date, type.id]
        end
      else
        if params[:search]
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ? and media_type_id =?', "%#{params[:search]}%", type.id]
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => [media_type_id =?', type.id]
        end
      end
    else
      if Useful.date?(params[:last_use_date])
        last_use_date = Date.parse(params[:last_use_date]).strftime('%F')
        if params[:search]
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ? and DATE(last_use) <= ?', "%#{params[:search]}%", last_use_date]
        else
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['DATE(last_use) <= ?', last_use_date]
        end
      else
        if params[:search]
          paginate  :per_page => 12, :page =>params[:page],
                    :conditions => ['name LIKE ?', "%#{params[:search]}%"]
        else
          paginate  :all, :per_page => 12, :page =>params[:page]
        end
      end
    end
      
  end
  
  
  def self.update_all_to_countdown_ipp
    type = MediaType.find_by_name('Countdown IPP')
    all.each do |m|
      if !m.media_type then
        m.media_type = type
        m.save
      end
    end
  end
  
  def self.add_countdown_ipp(countdown_ipp)
    num_days = (countdown_ipp.last_use.to_i - countdown_ipp.first_use.to_i)/86400.to_i

    if num_days > 0
      countdown_ipp.media_files.destroy_all
      n = num_days
      aspects=[]
      aspects << Aspect.find_by_name("4x3 SD")
      aspects << Aspect.find_by_name("16x9 SD")
      
      while n >= 0
        aspects.each do |asp|
          logger.debug '======<>'
          logger.debug asp.file_suffix
          file = MediaFile.new
          file.name = create_name(countdown_ipp.name, n)
          file.filename = create_filename(file.name, countdown_ipp.first_use, '.cel', asp.file_suffix)
          file.first_use = file_first_use(countdown_ipp.first_use, n, num_days)
          file.last_use = file_last_use(countdown_ipp.first_use, countdown_ipp.last_use, n, num_days)
          file.media_folder = MediaFolder.find_by_name_and_channel('Countdown IPP', countdown_ipp.channel)
          file.media_type = MediaType.find_by_name('Countdown IPP')
          if file.save
            countdown_ipp.add_file file
          end
        end
        n -= 1
      end
    end
  end

  def status_display
    if status
      status.message
    else
      ''
    end
  end
          
  def quicktime_filename
    File.basename(filename, ".*") + ".mov"
  end
  
  def mp4_filename
    File.basename(filename, ".*") + ".mp4"
  end
    
  def targa_filename
    File.basename(filename, ".*") + ".tga"
  end
  
  def jpeg_filename
    File.basename(filename, ".*") + ".jpg"
  end
  
  def ppv_filename
    File.basename(filename, ".*") + ".ppv"
  end
  

  def self.update_2012
    folder_2012 = MediaFolder.find_by_name('Promo Clip 2012')
    if folder_2012
      mfs = find_all_by_media_folder_id(MediaFolder.find_by_name('Promo Clip'))
      converted = 0
      mfs.each do |mf|
        if mf.filename.length > 2 && mf.filename[0..1] == '12'
          mf.media_folder = folder_2012
          if mf.save
            converted +=1
          end
        end
      end
      converted
    else
      'Missing media folder Promo Clip 2012'
    end
  end
      
  def self.create_media(promo, type, first_use, last_use)

      file = MediaFile.new
      file.name = promo.name
      
#      file.first_use = promo.first_use
#      file.last_use = promo.last_use

      if first_use.nil?
        first_use = Date.today.to_datetime.advance(:days => 1, :hours => 5)
      end
      six_month = first_use.advance(:months => 6)
      if last_use.nil?
        last_use = six_month
      else
        if last_use < six_month
          last_use = six_month
        end
      end
        
      file.first_use = first_use
      file.last_use = last_use
      file.status = Status.find_by_value(0)
      
      case type
      when 'clip'
        file.filename = create_filename(file.name, file.first_use, '.ppv',"")
        year_no = Useful.year_number(file.first_use)
        if year_no.to_i >= 2012
          media_f = MediaFolder.find_by_name('Promo Clip ' + year_no)
          if media_f
            if overflow(media_f, false)
              media_f = overflow_folder('Promo Clip Overflow', false)
              if !media_f
                media_f=MediaFolder.find_by_name('Promo Clip')
              end
            end
            file.media_folder = media_f
          else
            file.media_folder = MediaFolder.find_by_name('Promo Clip')
          end
        else
          file.media_folder = MediaFolder.find_by_name('Promo Clip')
        end
        file.media_type = MediaType.find_by_name('Promo Clip')
      when 'still'
        file.filename = create_filename(file.name, promo.first_use, '.tga',"")
        file.media_folder = MediaFolder.find_by_name('Promo Still')
        file.media_type = MediaType.find_by_name('Promo Still')
	  when 'portrait'
        file.filename = create_filename(file.name, promo.first_use, '.tga',"_POR")
        file.media_folder = MediaFolder.find_by_name('Portrait Still')
        file.media_type = MediaType.find_by_name('Portrait Still')
      when 'clipaudio'  
        file.filename = create_filename(file.name, file.first_use, '.ppv',"")
        file.audio_filename = file.filename.sub('.ppv',' (A1&2).ppa')
        file.has_audio = true
        year_no = Useful.year_number(file.first_use)
        if year_no.to_i >= 2012
          media_f = MediaFolder.find_by_name('Promo Clip Audio ' + year_no)
          if media_f
            if overflow(media_f, true)
              media_f = overflow_folder('Promo Clip Audio Overflow', true)
              if !media_f
                media_f=MediaFolder.find_by_name('Promo Clip')
              end
            end
            file.media_folder = media_f
          else
            file.media_folder = MediaFolder.find_by_name('Promo Clip')
          end
        else
          file.media_folder = MediaFolder.find_by_name('Promo Clip')
        end
        file.media_type = MediaType.find_by_name('Promo Clip Audio')
      end
      
      if file.save
        promo.add_file file
      end
      file
  end
  
  def self.create_name(name, days)
    name + " " + "%02d" % days
  end
  
  def self.create_filename(name, first_use, extension, aspect)
    
    if aspect.nil? then
      aspect=""
    end

    n = Useful.filename_year_week(first_use)  + '_' + Useful.strip_filename(name).upcase + aspect + extension
    i = 0
    while find_by_filename(n)
      i+=1
      n = Useful.filename_year_week(first_use)  + '_' + Useful.strip_filename(name).upcase + aspect + "_" + "%02d" % i + extension
    end
    n
  end
  
  def self.file_first_use(first_use, day, num_days)
    first_use.advance(:days => (num_days-day))
  end  
  
  def self.file_last_use(first_use, last_use, day, num_days)
    
    file_last = first_use.advance(:days => (num_days-day + 1))
    if file_last > last_use
      last_use
    else
      file_last
    end    
  end  
  
  def self.upload(params)
    media = find(params[:id])
    do_it = false
    
    if media
      upload_file = params[:file]
      media.issue = false
      case media.media_type.name
      when 'Promo Clip'
        case upload_file.content_type 
        when 'video/quicktime', 'application/octet-stream'
          if upload_file.content_type == 'video/quicktime'
            dest_filename = media.quicktime_filename
          else
            dest_filename = media.ppv_filename
          end
          media_folder_name = media.media_folder.name
          case media_folder_name
          when 'Promo Clip'
            filename = Rails.root.join('public','data', 'clip', dest_filename)
          when 'Promo Clip Overflow'
            filename = Rails.root.join('public','data', 'clip', 'Overflow', dest_filename)
          else
            if media_folder_name.downcase.include?('overflow')
              folder_num_string = media_folder_name[media_folder_name.rindex(' ') + 1..-1]
              if folder_num_string.to_i > 0
                filename = Rails.root.join('public','data', 'clip', 'Overflow' + folder_num_string, dest_filename)
              else
                filename = Rails.root.join('public','data', 'clip', 'Overflow' , dest_filename)
              end
            else
              year_string = media_folder_name[-4..-1]||'0'
              if year_string.to_i > 0 
                filename = Rails.root.join('public','data', 'clip', year_string, dest_filename)
              else
                filename = Rails.root.join('public','data', 'clip', dest_filename)
              end
            end
          end
          do_it = true
        else
          media.notice = "Invalid file type. Expected: video/quicktime. Uploaded: " + upload_file.content_type
          media.issue = true
          do_it = false
        end
      when 'Promo Still'
        case upload_file.content_type 
        when 'image/targa', 'image/x-targa', 'application/octet-stream'
          filename = Rails.root.join('public','data', 'still', media.targa_filename)
          do_it = true
        else
          media.notice = "Invalid file type. Expected: image/targa. Uploaded: " + upload_file.content_type
          media.issue = true
          do_it = false
        end
	    when 'Portrait Still'
        case upload_file.content_type 
        when 'image/targa', 'image/x-targa', 'application/octet-stream'
          filename = Rails.root.join('public','data', 'still', media.targa_filename)
          do_it = true
		   else
          media.notice = "Invalid file type. Expected: image/targa. Uploaded: " + upload_file.content_type
          media.issue = true
          do_it = false
		    end
      when 'Promo Clip Audio'
        case upload_file.content_type 
        when 'video/quicktime', 'application/octet-stream'
          if upload_file.content_type == 'video/quicktime'
            dest_filename = media.quicktime_filename
          else
            dest_filename = media.ppv_filename
          end
          media_folder_name = media.media_folder.name
          case media_folder_name
          when 'Promo Clip'
            filename = Rails.root.join('public','data', 'clip', dest_filename)
          when 'Promo Clip Audio Overflow'
            filename = Rails.root.join('public','data', 'clip', 'Overflow_audio', dest_filename)
          else
          if media_folder_name.downcase.include?('overflow')
              folder_num_string = media_folder_name[media_folder_name.rindex(' ') + 1..-1]
              if folder_num_string.to_i > 0
                filename = Rails.root.join('public','data', 'clip', 'Overflow_audio' + folder_num_string, dest_filename)
              else
                filename = Rails.root.join('public','data', 'clip', 'Overflow_audio' , dest_filename)
              end
            else
              year_string = media_folder_name[-4..-1]||'0'
              if year_string.to_i > 0 
                filename = Rails.root.join('public','data', 'clip', year_string + '_audio', dest_filename)
              else
                filename = Rails.root.join('public','data', 'clip', dest_filename)
              end
            end
          end
          do_it = true
        else
          media.notice = "Invalid file type. Expected: video/quicktime. Uploaded: " + upload_file.content_type
          media.issue = true
          do_it = false
        end
      when 'Special Preview'
        case upload_file.content_type 
        when 'video/quicktime'
          dest_filename = media.quicktime_filename
          filename = Rails.root.join('public','data', 'special', dest_filename)
          do_it = true
        else
          media.notice = "Invalid file type. Expected: video/quicktime. Uploaded: " + upload_file.content_type
          media.issue = true
          do_it = false
        end
      when 'Special Media'
        case upload_file.content_type 
        when 'image/targa', 'image/x-targa', 'application/octet-stream'
          if media.dynamic_special_media && media.dynamic_special_media.dynamic_special_image_spec
            filename = Pathname.new("#{Rails.root}/public" + media.dynamic_special_media.dynamic_special_image_spec.upload_folder + media.targa_filename)
            do_it = true
          else
            media.notice = "Issue with media type: " 
            media.issue = true
            do_it = false  
          end
        else
          media.notice = "Invalid file type. Expected: image/targa. Uploaded: " + upload_file.content_type
          media.issue = true
          do_it = false
        end
      else
        media.notice = "The system currently cannot upload this kind of file"
        do_it = false
        media.issue = true
      end
    
      
      if do_it
        create_folder_if_not_exist(filename)        
        File.open(filename, 'wb') do |file|
          file.write(upload_file.read)
        end
        media.original_filename = upload_file.original_filename
        media.notice = upload_file.original_filename + " uploaded. Content type: " + upload_file.content_type
        media.status = Status.find_by_message('Queued')
        case media.media_type.name
        when 'Promo Clip'
          case upload_file.content_type 
          when 'application/octet-stream'
            wd_copy(media.original_filename, filename)
          end
        when 'Special Preview'
          media.first_use = Time.current
          media.last_use = Time.current + 3.months
        end
      end
    end
    media.save
    media
  end
  
def self.wd_copy(original_filename, filename)
    wd_qt = clip_quicktime_wd_proxy_folder.join(File.basename(original_filename, ".*") + ".mov")
    if File.exist?(wd_qt)
      qt = clip_quicktime_proxy_folder.join(File.basename(filename, ".*") + ".mov")
      FileUtils.copy(wd_qt, qt)
    end
    wd_jpeg = clip_jpeg_wd_proxy_folder.join(File.basename(original_filename, ".*") + ".jpg")
    if File.exist?(wd_jpeg)
      jp = clip_jpeg_proxy_folder.join(File.basename(filename, ".*") + ".jpg")
      FileUtils.copy(wd_jpeg, jp)
    end
  end
    
  def clip_jpeg_proxy_folder
    Rails.root.join('public','data', 'proxies', 'clip', 'jpeg')
  end
  
  def self.clip_jpeg_proxy_folder
    Rails.root.join('public','data', 'proxies', 'clip', 'jpeg')
  end
  
  def self.clip_jpeg_wd_proxy_folder
    Rails.root.join('public','data', 'proxies', 'clip', 'jpeg', 'wd')
  end
  
  def clip_quicktime_proxy_folder
    Rails.root.join('public','data', 'proxies', 'clip', 'movs')
  end

  def clip_special_quicktime_proxy_folder
    Rails.root.join('public','data', 'proxies', 'special', 'movs')
  end

  def self.clip_quicktime_proxy_folder
    Rails.root.join('public','data', 'proxies', 'clip', 'movs')
  end

  def self.clip_quicktime_wd_proxy_folder
    Rails.root.join('public','data', 'proxies', 'clip', 'movs', 'wd')
  end

  def still_jpeg_proxy_folder
    Rails.root.join('public','data', 'proxies', 'still')
  end
  
  def self.still_jpeg_wd_proxy_folder
    Rails.root.join('public','data', 'proxies', 'still', 'wd')
  end

  def clip_jpeg_proxy_path
    "/data/proxies/clip/jpeg/"
  end

  def clip_special_jpeg_proxy_path
    "/data/proxies/special/jpeg/"
  end
  
  def clip_special_jpeg_url
    clip_special_jpeg_proxy_path + jpeg_filename
  end

  def dynamic_special_proxy_jpeg_url
    dynamic_special_proxy_path + jpeg_filename
  end

  def clip_jpeg_url
    clip_jpeg_proxy_path + jpeg_filename
  end
  
  def clip_quicktime_proxy_path
    "/data/proxies/clip/movs/"
  end

  def clip_special_proxy_path
    "/data/proxies/special/movs/"
  end

  def clip_special_jpeg_proxy_folder
    Rails.root.join('public','data', 'proxies', 'special', 'jpeg')
  end

  def dynamic_special_proxy_folder
    if dynamic_special_media && dynamic_special_media.dynamic_special_image_spec
      Pathname.new("#{Rails.root}/public" + dynamic_special_media.dynamic_special_image_spec.display_folder)
    else
      nil
    end
  end
  
  def dynamic_special_proxy_path
    if dynamic_special_media && dynamic_special_media.dynamic_special_image_spec
      dynamic_special_media.dynamic_special_image_spec.display_folder
    else
      nil
    end
  end

  def clip_quicktime_url
    clip_quicktime_proxy_path + quicktime_filename
  end
  
  def clip_mp4_url
    case media_type.name
    when 'Special Preview'
      clip_special_proxy_path + mp4_filename
    else
      clip_quicktime_proxy_path + mp4_filename
    end
  end
  
  def still_jpeg_proxy_path
    "/data/proxies/still/"
  end
  
  def still_jpeg_url
    still_jpeg_proxy_path + jpeg_filename
  end
  
  def jpeg_url
    case media_type.name
    when 'Promo Clip'
      clip_jpeg_url
    when 'Promo Clip Audio'
      clip_jpeg_url
    when 'Promo Still'
      still_jpeg_url
	  when 'Portrait Still'
      still_jpeg_url
    when 'Trailer ECP'
      clip_jpeg_url
    when 'Special Preview'
      clip_special_jpeg_url
    when 'Special Media'
      dynamic_special_proxy_jpeg_url
    else
      ""
    end
  end
  
  def jpeg_exist?
    case media_type.name
    when 'Promo Clip'
      File.exist?(clip_jpeg_proxy_folder.join(jpeg_filename))
    when 'Promo Clip Audio'
      File.exist?(clip_jpeg_proxy_folder.join(jpeg_filename))
    when 'Promo Still'
      File.exist?(still_jpeg_proxy_folder.join(jpeg_filename))
	  when 'Portrait Still'
      File.exist?(still_jpeg_proxy_folder.join(jpeg_filename))
    when 'Trailer ECP'
      File.exist?(clip_jpeg_proxy_folder.join(jpeg_filename))
    when 'Special Preview'
      File.exist?(clip_special_jpeg_proxy_folder.join(jpeg_filename))
    when 'Special Media'
      dsp_folder = dynamic_special_proxy_folder
      if dsp_folder
        File.exists?(dsp_folder.join(jpeg_filename))
      else
        false
      end
    else
      false
    end
  end
  
  def portrait?
    case media_type.name
    when 'Portrait Still'
      true
    else
      false
    end
  end
  
  def quicktime_exist?
    case media_type.name
    when 'Promo Clip', 'Promo Clip Audio'
      File.exist?(clip_quicktime_proxy_folder.join(quicktime_filename))
    else
      false
    end
  end
  
  def mp4_exist?
    case media_type.name
    when 'Promo Clip', 'Promo Clip Audio', 'Trailer ECP'
      File.exist?(clip_quicktime_proxy_folder.join(mp4_filename))
    when 'Special Preview'
      File.exist?(clip_special_quicktime_proxy_folder.join(mp4_filename))
    else
      false
    end
  end
  
  def status_css
    if status
      case status.value
      when -1
        'error'
      when 0
        'not_loaded'
      when 1
        'waiting'
      when 2..10
        'processing'
      when 11
        'ready'
      end
    end
  end

  def self.change_last_use(id, new_last_use)
    m = find(id)
    m.last_use = new_last_use
    if m.save
      return true
    else
      return false
    end
  end
  
  def self.overflow(media_f, with_audio)
    number_in_folder = find(:all, :conditions => ['media_folder_id = ?' ,media_f]).size
    if number_in_folder
      if with_audio
        return number_in_folder > MAX_FOLDER_WITH_AUDIO_CLIPS
      else
        return number_in_folder > MAX_FOLDER_CLIPS
      end
    else
      return false
    end
  end
  
  def self.overflow_folder(base_folder_name, with_audio)
    base_folder = MediaFolder.find_by_name(base_folder_name)
    return nil if !base_folder
    return base_folder if !overflow(base_folder, with_audio)

    folder_num = 2
    test_folder_name = base_folder_name + ' ' + folder_num.to_s
    test_folder = MediaFolder.find_by_name(test_folder_name)
    
    while overflow(test_folder, with_audio)
      folder_num += 1
      test_folder_name = base_folder_name + ' ' + folder_num.to_s
      test_folder = MediaFolder.find_by_name(test_folder_name)
      return nil if !test_folder
    end
    return test_folder
    
  end
     
  def self.create_folder_if_not_exist(filename)
    dirname = File.dirname(filename)
    Dir.mkdir(dirname) unless File.directory?(dirname)
  end

  def media_type_display
    display=''
    if media_type
      display = media_type.name
      if media_type.name == 'Special Media'
        if dynamic_special_media && dynamic_special_media.dynamic_special_image_spec
            display = media_type.name + ': ' + dynamic_special_media.dynamic_special_image_spec.name
        end
      end
    end
    display
  end

  def media_type_size
    size = nil
    if media_type
      if media_type.name == 'Special Media'
        if dynamic_special_media && dynamic_special_media.dynamic_special_image_spec
            size = dynamic_special_media.dynamic_special_image_spec.width.to_s + 'x' + dynamic_special_media.dynamic_special_image_spec.height.to_s
        end
      end
    end
    size
  end

  def preview_size
    size = nil
    if media_type
      if media_type.name == 'Special Media'
        if dynamic_special_media && dynamic_special_media.dynamic_special_image_spec
            size = (dynamic_special_media.dynamic_special_image_spec.width/4).to_s + 'x' + (dynamic_special_media.dynamic_special_image_spec.height/4).to_s
        end
      end
    end
    size
  end

  def full_filename
    if media_folder
      media_folder.folder + filename
    end
  end

  def self.new_with_default_values(params)
    m = MediaFile.new
    if params[:spec_id]
      spec = DynamicSpecialImageSpec.find(params[:spec_id])
      if spec
        m.media_type_id = MediaType.special_media.id
        m.media_folder_id = spec.media_folder_id
        m.first_use = Date.today.to_datetime.advance(:days => 1, :hours => 5)
        m.last_use = m.first_use.advance(:years => 10)
        m.status_id = Status.find_by_message('Not loaded').id
        m.source = 'New Dynamic Special Media'
        m.dynamic_special_media_id = params[:dynamic_special_media_id]
        m.next_prefix = DynamicSpecialMedia.next_picture_prefix('PICT_', spec.name)
        m.automated_dynamic_special_id = params[:automated_dynamic_special_id]
        m.field_id = params[:field_id]
      end
    end
    m
  end    
  
    
end
