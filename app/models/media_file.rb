class MediaFile < ActiveRecord::Base

  belongs_to :media_folder
  has_and_belongs_to_many :countdown_ipps
  has_and_belongs_to_many :promos
  belongs_to :media_type
  belongs_to :status
  has_one :trailer
  has_one :special_preview
  has_one :sports_ipp
  has_one :dynamic_special_media
  
  default_scope :order => 'first_use, media_type_id, filename'
  validates_uniqueness_of :filename, :message => " is already in the system"
  validates_uniqueness_of :name, :if => :not_portrait_media?, :message => " is already in the system for this media type"

  MAX_FOLDER_CLIPS = 450
  MAX_FOLDER_WITH_AUDIO_CLIPS = 225
  
  require 'useful'
  require 'shellwords'

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
  attr_accessor :resize
  
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

  def png_filename
    File.basename(filename, ".*") + ".png"
  end
  
  def jpeg_filename
    File.basename(filename, ".*") + ".jpg"
  end
  
  def ppv_filename
    File.basename(filename, ".*") + ".ppv"
  end

  def temp_folder
    "#{Rails.root}/public/temp/"
  end

  def temp_png
    '/temp/'+ png_filename
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
      media.resize = false
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
      when 'Special Preview', 'Sports IPP Preview'
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
        #sort out temporary filename of temporary file
        #different for tga, png and jpeg
        case upload_file.content_type 
        when 'image/targa', 'image/x-targa', 'application/octet-stream', 'image/png', 'image/jpeg'
          if media.dynamic_special_media && media.dynamic_special_media.dynamic_special_image_spec
            filename = media.filename_for_content_type(upload_file.content_type)
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
        if media.media_type.name == 'Special Media'
          media.automated_dynamic_special_id = params[:automated_dynamic_special_id]
          #process the file
          result = media.process_special_media_upload(filename, upload_file.content_type)
          # returns a hash of
            # :action => one of :use, :resize, :reject
            # :reason => text of a message as to why rejected
            # :size => hash of width x height
          if result[:action] == :use
            # copy to the upload folder
            media.copy_special_to_upload_folder
          elsif result[:action] == :resize
            media.resize = true

          else
            media.issue =true
            media.notice = result[:reason]
          end
        else
          media.status = Status.find_by_message('Queued')
          case media.media_type.name
          when 'Promo Clip'
            case upload_file.content_type 
            when 'application/octet-stream'
              wd_copy(media.original_filename, filename)
            end
          when 'Special Preview', 'Sports IPP Preview'
            media.first_use = Time.current
            media.last_use = Time.current + 3.months
          end
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

  def specials_original_path
    Rails.root.join('public','data', 'special', 'Originals')
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
    when 'Special Preview', 'Sports IPP Preview'
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
    when 'Special Preview', 'Sports IPP Preview'
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
    when 'Special Preview', 'Sports IPP Preview'
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
    when 'Special Preview', 'Sports IPP Preview'
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

  def media_type_resizeable
    result = false
    if media_type
      if media_type.name == 'Special Media'
        if dynamic_special_media && dynamic_special_media.dynamic_special_image_spec
            result = dynamic_special_media.dynamic_special_image_spec.resizable
        end
      end
    end
    result
  end

  def media_dimensions
    result = {}
    result[:valid] = false
    result[:width] = 0
    result[:height] = 0
    if media_type
      if media_type.name == 'Special Media'
        if dynamic_special_media && dynamic_special_media.dynamic_special_image_spec
          result[:valid] = true
            result[:width] = dynamic_special_media.dynamic_special_image_spec.width
            result[:height] = dynamic_special_media.dynamic_special_image_spec.height
        end
      end
    end
    result
  end

  def preview_size
    size = nil
    if media_type
      if media_type.name == 'Special Media'
        if dynamic_special_media && dynamic_special_media.dynamic_special_image_spec
            size = (dynamic_special_media.dynamic_special_image_spec.width/2).to_s + 'x' + (dynamic_special_media.dynamic_special_image_spec.height/2).to_s
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
  
  def process_special_media_upload(file, content_type)
    # returns a hash of
    # :action => one of :use, :resize, :reject
    # :reason => text of a message as to why rejected
    # :size => hash of width x height
    case content_type 
    when 'image/targa', 'image/x-targa', 'application/octet-stream'
      #already a targa so check size.
      check_size = size_match(file)
      if check_size[:action] == :exact
        result = {:action => :use}
        #if size is OK then no need to resize so pass on.
        copy_to_originals_folder(file)
      elsif (check_size[:action] == :resize) && media_type_resizeable
        if convert_to_png(file)
          result = {:action => :resize, :size => check_size[:size]}
        else
          result = {:action => :reject, :reason => "Failed to create png file"}
        end
        move_to_originals_folder(file)
      else
        move_to_originals_folder(file)
        result = {:action => :reject, :reason => check_size[:reason], :size => check_size[:size]}
      end
    when 'image/png'
      check_size = size_match(file)
      if check_size[:action] == :exact
        #if size is OK then convert to targa and pass on
        if convert_to_tga(file)
          result = {:action => :use}
        else
          result = {:action => :reject, :reason => "Failed to create tga file from png"}
        end
        move_to_originals_folder(file)
      elsif check_size[:action] == :resize
        #if size is within range then send to resize.
        result = {:action => :resize, :size => check_size[:size]}
        copy_to_originals_folder(file)
      else
        #otherwise reject
        result = {:action => :reject, :reason => check_size[:reason], :size => check_size[:size]}
        move_to_originals_folder(file)
      end
    when'image/jpeg'
      #if size is OK then convert to targa and pass on
      check_size = size_match(file)
      if check_size[:action] == :exact
        #if size is OK then convert to targa and pass on
        if convert_to_tga(file)
          result = {:action => :use}
        else
          result = {:action => :reject, :reason => "Failed to create tga file from png"}
        end
        move_to_originals_folder(file)
      #if size is within range then create png and send to resize.
      elsif check_size[:action] == :resize
        if convert_to_png(file)
          result = {:action => :resize, :size => check_size[:size]}
        else
          result = {:action => :reject, :reason => "Failed to create png file"}
        end
        move_to_originals_folder(file)
      else
        #otherwise reject
        result = {:action => :reject, :reason => check_size[:reason], :size => check_size[:size]}
        move_to_originals_folder(file)
      end
    else
      result = {:action => :reject, :reason => "Invalid content type."}
    end
    result
  end

  def self.image_dimensions(file)
    result = {:valid => false}
    if file.exist?
      escaped_filename = file.to_s.shellescape
      dimensions = IO.popen("identify -format %w,%h " + escaped_filename).readlines[0].strip.split(",")
      if dimensions.length == 2
        result = {:width => dimensions[0].to_i, :height => dimensions[1].to_i, :valid => true}
      end
    end
    result
  end

  def size_match(file)
    result = {:action => :reject}
    dimensions = self.class.image_dimensions(file)
    if dimensions[:valid]
      if dynamic_special_media && dynamic_special_media.dynamic_special_image_spec
        width = dynamic_special_media.dynamic_special_image_spec.width
        height = dynamic_special_media.dynamic_special_image_spec.height
        lower_limit_width = 0.8 * width
        lower_limit_height = 0.8 * height
        higher_limit_width = 2000
        higher_limit_height = 2000

        if width == dimensions[:width] && height == dimensions[:height]
          result = {:action => :exact, :size => {:width => width, :height => height }}
        else
          if media_type_resizeable
            if (dimensions[:width] > lower_limit_width) and (dimensions[:height] > lower_limit_height)
              if (dimensions[:width] < higher_limit_width) and (dimensions[:height] < higher_limit_height)
                result = {:action => :resize, :size => {:width => width, :height => height }}
              else
                result = {:action => :reject, :reason => 'Image too large. It must be less than ' + higher_limit_width.to_s + ' x ' + higher_limit_height.to_s + '. Uploaded size: ' + dimensions[:width].to_i.to_s + " x " + dimensions[:height].to_i.to_s, :size => {:width => width, :height => height }}
              end
            else
              result = {:action => :reject, :reason => 'Image too small. It must be greater than ' + lower_limit_width.to_i.to_s + " x " + lower_limit_height.to_i.to_s + '. Uploaded size: ' + dimensions[:width].to_i.to_s + " x " + dimensions[:height].to_i.to_s, :size => {:width => dimensions[:width], :height => dimensions[:height]}}
            end
          else
            result = {:action => :reject, :reason => 'Image is the wrong size. It must be ' + width.to_i.to_s + " x " + height.to_i.to_s + '. Uploaded size: ' + dimensions[:width].to_i.to_s + " x " + dimensions[:height].to_i.to_s, :size => {:width => dimensions[:width], :height => dimensions[:height]}}
          end
        end
      else
        result = {:action => :reject, :reason => "Invalid media"}
      end
    else
      result = {:action => :reject, :reason => "Cannot measure dimensions"}
    end
    result
  end

  def convert_to_png(file)
    if file.exist?
      escaped_filename = file.to_s.shellescape
      png_file = temp_folder + png_filename
      escaped_png_filename = png_file.shellescape
      result = IO.popen("convert " + escaped_filename + ' ' + escaped_png_filename)
      wait_until_stable_file_size png_file
      if result
        true
      else
        false
      end
    else
      false
    end  
  end

  def wait_until_stable_file_size(filename)
    logger.debug 'Im here=============================='
    last_size = -1
    for i in 1..100
      if File.exist?(filename)
        this_size = File.size(filename)
        logger.debug this_size
        if this_size ==  last_size
          break
        else
          last_size = this_size
        end
      else
        logger.debug 'Does not exist'
      end
      sleep 0.1
    end
  end

  def convert_to_tga(file)
    if file.exist?
      escaped_filename = file.to_s.shellescape
      tga_filename = temp_folder + targa_filename
      escaped_tga_filename = tga_filename.shellescape
      result = IO.popen("convert " + escaped_filename + ' ' + escaped_tga_filename)
      wait_until_stable_file_size tga_filename
      if result
        true
      else
        false
      end
    else
      false
    end  
  end

  def do_resize(file, the_scale)
    if file.exist?
      escaped_filename = file.to_s.shellescape
      tga_filename = temp_folder + targa_filename
      escaped_tga_filename = tga_filename.shellescape
      result = IO.popen("convert " + escaped_filename + ' -resize ' + (the_scale * 100).to_s + '% ' + escaped_tga_filename)
      wait_until_stable_file_size tga_filename
      if result
        true
      else
        false
      end
    else
      false
    end 
  end

  def resize_then_crop(file, the_scale, crop_x, crop_y, offset_x, offset_y)
    if file.exist?
      escaped_filename = file.to_s.shellescape
      tga_filename = temp_folder + targa_filename
      escaped_tga_filename = tga_filename.shellescape
      result = IO.popen("convert " + escaped_filename + ' -resize ' + (the_scale * 100).to_s + '% ' + ' -crop ' + crop_x.to_s + 'x' + crop_y.to_s + '+' + offset_x.to_s + '+' + offset_y.to_s + ' ' + escaped_tga_filename)
      wait_until_stable_file_size tga_filename
      if result
        true
      else
        false
      end
    else
      false
    end
  end


  def do_the_crop(params)
    the_x_offset = params[:x_offset].to_f.round
    the_y_offset = params[:y_offset].to_f.round
    the_scale = params[:scale].to_f

    png_file = Pathname.new(temp_folder + png_filename)
    dimensions = self.class.image_dimensions(png_file)
    if dimensions[:valid]
      if dynamic_special_media && dynamic_special_media.dynamic_special_image_spec
        width = dynamic_special_media.dynamic_special_image_spec.width
        height = dynamic_special_media.dynamic_special_image_spec.height
        min_scale = width.to_f/dimensions[:width].to_f
        if the_scale < min_scale 
          the_scale = min_scale
        end
        if (the_x_offset == 0) && (the_y_offset == 0)
          #just the scaling to do
          if do_resize(png_file, the_scale)
            true
          else
            false
          end
        else
          #scale then crop
          resize_then_crop(png_file, the_scale, width, height, the_x_offset, the_y_offset)
        end
      end
    end
    if File.exist?(png_file)
      File.delete(png_file)
    end
  end

  def copy_special_to_upload_folder
    temp_targa = temp_folder + targa_filename
    final_targa = "#{Rails.root}/public" + dynamic_special_media.dynamic_special_image_spec.upload_folder + targa_filename
    if File.exist?(temp_targa)
      FileUtils.copy(temp_targa, final_targa)
      self.status = Status.find_by_message('Queued')
      File.delete(temp_targa)
      self.notice = targa_filename + ' uploaded.'
    else
      self.issue = true
      self.notice = 'Could not copy targa image to correct folder'
    end
  end

  def complete_the_upload
    copy_special_to_upload_folder
    self.save
  end

  def move_to_originals_folder(file)
    if file.exist?
      FileUtils.mv file, specials_original_path + original_filename
    end
  end

  def copy_to_originals_folder(file)
    if file.exist?
      FileUtils.cp file, specials_original_path + original_filename
    end
  end

  def redo_the_resize
    #Find the original
    original = specials_original_path + original_filename
    if original.exist?
      the_content_type = content_type_for_extension(original)
      temp_filename = filename_for_content_type(the_content_type)
      FileUtils.copy original, temp_filename
      wait_until_stable_file_size temp_filename
      if temp_filename.exist?
        if the_content_type != 'image/png'
          convert_to_png(temp_filename)
          temp_filename.delete
        end
        true
      else
        false
      end
    else
      false
    end
  end

  def filename_for_content_type(content_type)
    case content_type 
    when 'image/targa', 'image/x-targa', 'application/octet-stream'
      filename = Pathname.new(temp_folder + targa_filename)
    when 'image/png'
      filename = Pathname.new(temp_folder + png_filename)
    when'image/jpeg'
      filename = Pathname.new(temp_folder + jpeg_filename)
    end
    filename
  end

  def content_type_for_extension(filename)
    case filename.extname
    when '.jpg', 'jpeg'
      'image/jpeg'
    when '.png'
      'image/png'
    when '.tga'
      'image/targa'
    end
  end

  def delete_temp_png
    filename = Pathname.new(temp_folder + png_filename)
    if filename.exist?
      filename.delete
    end
  end

  def self.recent_special_previews(params)
    type_special_preview = MediaType.find_by_name('Special Preview')
    type_sports_ipp_preview = MediaType.find_by_name('Sports IPP Preview')
    if params[:not_loaded]
      status = Status.find_by_message("Not loaded")
      position = params[:pos].to_i
      if position.nil? || position <= 0
        position = 1
      end
      paginate  :per_page => 1, :page => position,
                :conditions => ['(media_type_id = ? OR media_type_id = ?) AND status_id = ?', type_special_preview.id, type_sports_ipp_preview, status.id], :order => 'created_at DESC'
    else
      paginate  :per_page => 5, :page =>params[:page],
                :conditions => ['media_type_id = ?', type_special_preview.id], :order => 'created_at DESC'
    end
  end 

  def automated_dynamic_special
    if special_preview && special_preview.automated_dynamic_special
      special_preview.automated_dynamic_special
    else
      nil
    end
  end

  def not_portrait_media?
    portrait = MediaType.find_by_name('Portrait Still')
    media_type_id != portrait.id
  end

  def self.find_sports_ipp_previews(filename)
    sports_ipp_preview_type = MediaType.find_by_name('Sports IPP Preview')
    find :all, :conditions => ['media_type_id = ? AND filename = ?', sports_ipp_preview_type.id, filename ]
  end

  def deal_with_sports_ipp_status
    sports_ipp_preview_type = MediaType.find_by_name('Sports IPP Preview')
    ready_status = Status.find_by_message('Ready')
    preview_ready_status = SportsIppStatus.find_by_message('Preview Ready')
    sports_ipp_ready_status = SportsIppStatus.find_by_message('Ready')
    if status == ready_status && media_type == sports_ipp_preview_type
      if sports_ipp && sports_ipp.sports_ipp_media && sports_ipp.sports_ipp_media.sports_ipp_status
        if sports_ipp.sports_ipp_media.sports_ipp_status.message == "Not Loaded"
          the_media = SportsIppMedia.find(sports_ipp.sports_ipp_media_id)
          the_media.sports_ipp_status_id = preview_ready_status.id
        elsif sports_ipp.sports_ipp_media.sports_ipp_status.message == "Package Ready"
          the_media = SportsIppMedia.find(sports_ipp.sports_ipp_media_id)
          the_media.sports_ipp_status_id = sports_ipp_ready_status.id
        end
      end
    end
  end

end
