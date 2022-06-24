class JpegFolder < ActiveRecord::Base
  
  has_many :jpegs, :dependent => :destroy
  
  JPEG_ROOT = Rails.root.join('public','images','clarity_jpeg', 'channels')
  
  def self.rescan_folders
    remove_deleted_folders
    if File.directory?(JPEG_ROOT)
      Dir.chdir(JPEG_ROOT)
      Dir['*'].each do |path|
        if File.directory?(path)
          f = find_or_create_by_name(path)
          f.save
        end
      end
      true
    else
      false
    end
#    all.each do |p|
#      scan_folder(p)
#    end
  end
  
  def full_path
    if name
      'clarity_jpeg/channels/' + name + '/'
    end
  end
  
  def self.scan_folder(folderid)
#    Jpeg.destroy_all(['jpeg_folder_id = ?', folderid])
    fold = find_by_id(folderid)
    folder = JPEG_ROOT.join(fold.name)
    if File.exists?(folder)
      Dir.chdir(folder)
      remove_deleted_file(fold)
      Dir['**/**'].each do |path|
        if File.extname(path) == ".jpg"
          if Jpeg.none_by_name_and_folder_id(path, folderid)
            f = Jpeg.new
            f.name = path
            f.filename = f.name
            f.jpeg_folder = fold
            f.save
          end
        else
          Jpeg.delete_by_name_and_folder_id(path, folderid)
        end
      end
    else
      Jpeg.destroy_all(['jpeg_folder_id = ?', folderid])
    end
  end
  
  def self.remove_deleted_folders
    all.each do |f|
      folder = JPEG_ROOT.join(f.name)
      if !(File.exists?(folder))
        f.destroy
      end
    end
  end
      
  def self.remove_deleted_file(folder)
    jpegs = Jpeg.find_all_by_jpeg_folder_id(folder.id)
    if jpegs
      jpegs.each do |j|
        if !(File.exists?(j.name))
          j.destroy
        end
      end
    end
  end
      
  def self.search(channel, page)
    if channel.nil?||channel == 'All'
      paginate  :per_page => 12, :page => page,
                :order => 'name DESC'
    else
      selected_channel = Channel.find_by_name(channel)
      if selected_channel
        prefix = selected_channel.prefix
        # Awful kludge to separate TV3PLUS and TV3PLUSNOR
        if prefix == 'TV3PLUS'
          prefix = 'TV3PLUS\\_'
        end
        logger.debug prefix
        paginate  :per_page => 12, :page => page,
                  :conditions => ['name like ?', "%#{prefix}%"],
                  :order => 'name DESC'
      else
        paginate  :per_page => 12, :page => page,
                  :order => 'name'
      end
    end
    
  end
  
  
  def self.display
    list = all
    folders = []
    
    list.each do |l|
      folders << [[l.name], l.id.to_s]
    end
    folders
  end
  
end
